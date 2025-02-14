//
//  ContentView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var projetos: [ProjectModel]
    
    @StateObject var projectVM = ProjectViewModel()
    @State var showAddProjectSheet = false
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var showDeleteAlert = false
    @State private var projectToDelete: ProjectModel?
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                if projetos.isEmpty {
                    Text("Você não está trabalhando em nenhum projeto. Que tal começar um novo?")
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)

                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(projetos) { project in
                                NavigationLink(destination: ProjectView(projectVM: projectVM, currentProject: project)) {
                                    VStack {
                                        if let imageData = project.image,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                                .clipped()
                                        } else {
                                            Image("DefaultImage")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        Text(project.name ?? "Sem Nome")
                                            .bold()
                                    }
                                    .padding()
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        projectToDelete = project
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                }
            }
            .navigationTitle("Projetos")
            .alert("Deletar Projeto", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Deletar", role: .destructive) {
                    if let projectToDelete = projectToDelete {
                        projectVM.deleteProject(project: projectToDelete, modelContext: modelContext)
                    }
                }
            } message: {
                Text("Tem certeza que deseja apagar este projeto? Esta ação não poderá ser desfeita.")
            }
            .toolbar {
                Button("Criar projeto") {
                    showAddProjectSheet.toggle()
                }
            }
            .sheet(isPresented: $showAddProjectSheet) {
                AddProjectView(projectVM: projectVM)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ProjectModel.self, inMemory: true)
}
