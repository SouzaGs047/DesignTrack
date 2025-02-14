//
//  EditProjectView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var projectVM = ProjectViewModel()
    var currentProject: ProjectModel
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var isEditing = false
    @State private var isBrandingExpanded = false
    
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    
    private let projectTypes = [
        "UX/UI Design",
        "Design de Jogos",
        "Design de Interfaces",
        "Design de Marca",
        "Design de Motion",
        "Design de Animação",
        "Outros"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    ImageView(selectedImages: $selectedImages, isEditing: isEditing) // Passa o estado isEditing
                }                .disabled(!isEditing)
                .onChange(of: selectedItems) { newItems in
                    selectedImages.removeAll()
                    for item in newItems {
                        Task {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                await MainActor.run {
                                    selectedImages.append(image)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Tipo")
                        .foregroundStyle(.accent)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    if isEditing {
                        Menu {
                            ForEach(projectTypes, id: \.self) { type in
                                Button(action: { projectVM.type = type }) {
                                    Text(type)
                                }
                            }
                        } label: {
                            HStack {
                                Text(projectVM.type.isEmpty ? "Selecione um tipo" : projectVM.type)
                                    .foregroundColor(projectVM.type.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                        }
                    } else {
                        Text(projectVM.type.isEmpty ? "" : projectVM.type)
                            .foregroundColor(.primary)
                            .padding()
                    }
                }
                
                .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
                
                VStack(alignment: .leading) {
                    Text("Objetivo")
                        .padding(.top)
                        .padding(.horizontal)
                        .foregroundStyle(.accent)
                        .bold()
                    
                    TextEditor(text: $projectVM.objective)
                        .frame(height: 100)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .scrollContentBackground(.hidden)
                        .disabled(!isEditing)
                }
                .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
                
                HStack(spacing: 40) {
                    VStack {
                        Text("Data de início")
                            .foregroundStyle(.accent)
                        
                        DatePicker("", selection: $projectVM.startDate, displayedComponents: .date)
                            .disabled(!isEditing)
                            .labelsHidden()
                    }
                    
                    
                    VStack {
                        Text("Prazo Final")
                            .foregroundStyle(.accent)
                        
                        DatePicker("", selection: $projectVM.finalDate, displayedComponents: .date)
                            .disabled(!isEditing)
                            .labelsHidden()
                    }
                }
                
                
                DisclosureGroup("Configurações de Branding", isExpanded: $isBrandingExpanded) {
                    BrandingView(currentProject: currentProject, isEditing: $isEditing)
                }
                .foregroundStyle(.primary)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .animation(.easeInOut, value: isBrandingExpanded)
                
                if isEditing {
                    Button(action: {
                        showDeleteConfirmation = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Deletar projeto")
                            Spacer()
                        }
                        .foregroundStyle(.red)
                    })
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(.red, lineWidth: 1))
                    .alert("Deletar Projeto", isPresented: $showDeleteConfirmation) {
                        Button("Cancelar", role: .cancel) {}
                        Button("Deletar", role: .destructive) {
                            projectVM.deleteProject(project: currentProject, modelContext: modelContext)
                            dismiss()
                        }
                    } message: {
                        Text("Tem certeza que deseja deletar este projeto? Esta ação não poderá ser desfeita.")
                    }
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollIndicators(.never)
        .onAppear {
            projectVM.type = currentProject.type ?? ""
            projectVM.objective = currentProject.objective ?? ""
            projectVM.startDate = currentProject.startDate ?? Date()
            projectVM.finalDate = currentProject.finalDate ?? Date()
            
            if let imageData = currentProject.image, let uiImage = UIImage(data: imageData) {
                selectedImages = [uiImage]
            }
        }
        .navigationBarItems(trailing: Button(action: {
            if isEditing {
                var imageData: Data? = nil
                if let firstImage = selectedImages.first {
                    imageData = firstImage.jpegData(compressionQuality: 0.0)
                }
                
                projectVM.updateProject(
                    project: currentProject,
                    type: projectVM.type,
                    objective: projectVM.objective,
                    startDate: projectVM.startDate,
                    finalDate: projectVM.finalDate,
                    image: imageData,
                    modelContext: modelContext
                )
            }
            isEditing.toggle()
        }) {
            Text(isEditing ? "Salvar" : "Editar")
                .bold()
                .foregroundStyle(.accent)
        })
    }
}

struct ImageView: View {
    @Binding var selectedImages: [UIImage]
    var isEditing: Bool
    
    var body: some View {
        ZStack {
            if let firstImage = selectedImages.first {
                Image(uiImage: firstImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image("DefaultImage")
                    .resizable()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.gray)
                    .frame(width: 200, height: 200)
                
    
                if isEditing {
                    Text("Clique para adicionar uma foto")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                }
            }
        }
    }
}


//#Preview {
//    EditProjectView()
//}
