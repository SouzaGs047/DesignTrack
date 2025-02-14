//
//  LogProjectView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import SwiftData

struct LogProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var logs: [LogModel]
    
    var currentProject: ProjectModel
    
    @StateObject private var logVm = LogViewModel()
    @State private var showDeleteAlert = false
    @State private var logToDelete: LogModel?
    @State private var searchText = ""
    
    var filteredLogs: [LogModel] {
        if searchText.isEmpty {
            return logs
        } else {
            return logs.filter { log in
                log.title.localizedCaseInsensitiveContains(searchText) ||
                (log.textContent?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var groupedLogs: [(date: Date, logs: [LogModel])] {
        let grouped = Dictionary(grouping: filteredLogs) { log in
            Calendar.current.startOfDay(for: log.date)
        }
        return grouped.map { (key, value) in
            (date: key, logs: value)
        }
        .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack {
            TextField("Digite um título ou conteúdo...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            List {
                ForEach(groupedLogs, id: \.date) { group in
                    Section(header: Text(formattedDate(group.date))) {
                        ForEach(group.logs, id: \.self) { log in
                            NavigationLink(destination: LogDetailView(log: log)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(log.title)
                                        .font(.headline)
                                    
                                    Text(log.textContent ?? "Sem conteúdo")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    
                                    if !log.images.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(log.images, id: \.self) { logImage in
                                                    if let uiImage = UIImage(data: logImage.imageData) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 75, height: 75)
                                                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                                            .clipped()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    logToDelete = log
                                    showDeleteAlert = true
                                } label: {
                                    Label("Deletar", systemImage: "trash")
                                }
                            }
                        }

                    }
                }
            }
            .listStyle(.plain)
        }
        .alert("Deletar Log", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Deletar", role: .destructive) {
                if let logToDelete = logToDelete {
                    logVm.deleteLog(log: logToDelete, modelContext: modelContext)
                }
            }
        } message: {
            Text("Tem certeza que deseja deletar este log?")
        }
        .toolbar {
            NavigationLink(destination: AddLogView(currentProject: currentProject)) {
                Text("Adicionar Log")
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
