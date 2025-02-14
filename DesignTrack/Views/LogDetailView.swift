//
//  LogDetailView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import PhotosUI

struct LogDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var logVM = LogViewModel()
    
    var log: LogModel
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var isEditing = false
    @State private var showImagePicker = false
    
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    let topics = ["Anotação", "Lousa", "Marca", "Pesquisa", "Progresso", "Referências", "Testes", "Visita Técnica", "Outros"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Divider()
                Menu {
                    ForEach(topics, id: \.self) { topic in
                        Button(topic) { logVM.title = topic }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(logVM.title)
                            .foregroundStyle(.accent)
                        Spacer()
                        Image(systemName: "chevron.down").foregroundStyle(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .disabled(!isEditing)
                .padding(.horizontal)
                .padding(.top)
                
                TextEditor(text: $logVM.textContent)
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.rosaPreto)
                    )
                    .frame(height: 250)
                    .padding(.horizontal)
                    .disabled(!isEditing)
  
                HStack {
                    Text("Imagens").foregroundStyle(.accent).font(.system(size: 20, weight: .bold))
                    Spacer()
                    if (isEditing) {
                        PhotosPicker(selection: $selectedItems, matching: .images) {
                            Text("Clique aqui para adicionar")
                                .foregroundStyle(.gray).font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                .clipped()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 0)
            
            if isEditing {
                VStack {
                    Button(action: {
                        showDeleteConfirmation = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Deletar Anotação")
                            Spacer()
                        }
                        .foregroundStyle(.red)
                    })
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(.red, lineWidth: 1))
                    .alert("Deletar Anotação", isPresented: $showDeleteConfirmation) {
                        Button("Cancelar", role: .cancel) {}
                        Button("Deletar", role: .destructive) {
                            logVM.deleteLog(log: log, modelContext: modelContext)
                            dismiss()
                        }
                    } message: {
                        Text("Tem certeza que deseja deletar esta anotação? Esta ação não poderá ser desfeita.")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                if (isEditing) {
                    logVM.updateLog(log: log, title: logVM.title, textContent: logVM.textContent, imagesData: selectedImages.compactMap { $0.jpegData(compressionQuality: 0.0) }, modelContext: modelContext)
                }
                isEditing.toggle()
            },label: {
                Text(isEditing ? "Salvar" : "Editar")
            })
        }
        .onChange(of: selectedItems) { _ in
            Task {
                for item in selectedItems {
                    if let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                        selectedImages.append(uiImage)
                    }
                }
            }
        }
        .onAppear {
            logVM.title = log.title
            logVM.textContent = log.textContent ?? ""
            selectedImages = log.images.compactMap { UIImage(data: $0.imageData) }
        }
    }
}

//#Preview {
//    LogDetailView()
//}
