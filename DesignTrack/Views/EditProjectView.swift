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
    
    // Estados para manipular a seleção de imagem usando PhotosPicker
    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var isEditing = false
    @State private var isBrandingExpanded = false
    
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
                // Utiliza o PhotosPicker diretamente para selecionar a imagem
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,    // Se deseja apenas uma imagem, ou 0 para ilimitado
                    matching: .images
                ) {
                    ImageView(selectedImages: $selectedImages)
                }
                .disabled(!isEditing)
                .onChange(of: selectedItems) { newItems in
                    // Se desejar substituir a imagem atual, limpe as anteriores:
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
                
                // Seleção de Tipo
                HStack {
                    Text("Tipo")
                        .foregroundStyle(.accent)
                        .bold()
                        .padding(.horizontal)
                    
                    Spacer()
                    
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
                    .disabled(!isEditing)
                }
                .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
                
                // Campo Objetivo
                VStack(alignment: .leading) {
                    Text("Objetivo")
                        .padding(.top, 5)
                        .padding(.horizontal)
                        .foregroundStyle(.accent)
                        .bold()
                    
                    TextEditor(text: $projectVM.objective)
                        .frame(height: 100)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .disabled(!isEditing)
                }
                .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
                
                // Campos de Data
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Data de início")
                            .foregroundStyle(.accent)

                        DatePicker("", selection: $projectVM.startDate, displayedComponents: .date)
                            .disabled(!isEditing)
                            .labelsHidden()
                    }

                    
                    VStack(alignment: .leading) {
                        Text("Prazo Final")
                            .foregroundStyle(.accent)

                        DatePicker("", selection: $projectVM.finalDate, displayedComponents: .date)
                            .disabled(!isEditing)
                            .labelsHidden()
                    }
                }
                
                
                VStack{
                    Button( action : {
                        withAnimation(.easeInOut){
                            isBrandingExpanded.toggle()
                        }
                    }){
                        HStack{
                            Text("Configurações de Branding")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: isBrandingExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if isBrandingExpanded{
                        BrandingView(currentProject: currentProject)
                        //Colocar a BrandingView
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
                    }
                }
                
                Button(action: {projectVM.deleteProject(project: currentProject, modelContext: modelContext)}, label: { Text("Apagar projeto")
                })
            }
            .padding()
        }
        .onAppear {
            // Popula o view model com os dados atuais do projeto
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
                // Ao clicar em "Salvar", converte a imagem e atualiza o projeto
                var imageData: Data? = nil
                if let firstImage = selectedImages.first {
                    imageData = firstImage.jpegData(compressionQuality: 1.0)
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
            // Alterna entre os modos "Editar" e "Visualizar"
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


//#Preview {
//    EditProjectView()
//}
