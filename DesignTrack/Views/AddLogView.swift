//
//  AddLogView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

//
//  AddLogView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddLogView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var logVM = LogViewModel()
    var currentProject: ProjectModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedOption: String?
    @State private var textContentLog: String = ""
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    let topics = [
        "Anotação", "Lousa", "Marca", "Pesquisa",
        "Progresso", "Referências", "Testes",
        "Visita Técnica", "Outros"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Divider()
            Menu {
                ForEach(topics, id: \.self) { topic in
                    Button(topic) {
                        selectedOption = topic
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption ?? "O que você quer registrar agora?")
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.primary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.linha, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            
            Divider()
            
            VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textContentLog)
                        .foregroundColor(Color(.white))
                        .padding(8)
                        .multilineTextAlignment(.leading)
                    if textContentLog.isEmpty {
                        Text("Clique aqui para digitar")
                            .foregroundColor(.gray)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 11)
                    }
                }
                .frame(height: 200)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.rosaPreto)
                )
                .padding(.horizontal)
                
                Divider()
                    .padding()
                
                HStack {
                    Text("Imagens")
                        .foregroundStyle(.accent)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.trailing, 60.0)
                    Spacer()
                    
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 0,
                        matching: .images
                    ) {
                        Text("Clique aqui para adicionar")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                    }
                    .onChange(of: selectedItems) { newItems in
                        Task {
                            var images: [UIImage] = []
                            for item in newItems {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    images.append(image)
                                }
                            }
                            selectedImages = images
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
                    .padding()
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("Escrever Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Registrar") {
                    guard let topic = selectedOption, !textContentLog.isEmpty else { return }
                    
                    let imagesData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.0) }
                    
                    logVM.addLog(project: currentProject,
                                 title: topic,
                                 textContent: textContentLog,
                                 imagesData: imagesData,
                                 modelContext: modelContext)
                    
                    dismiss()
                }
                .foregroundStyle(.accent)
            }
        }
    }
}



//#Preview {
//    AddLogView()
//}
