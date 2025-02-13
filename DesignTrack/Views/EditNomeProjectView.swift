import SwiftUI

struct EditNomeProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var projectVM: ProjectViewModel
    
    let project: ProjectModel
    @State private var nameProjectTextField: String
    @State private var showError: Bool = false
    @State private var characterLimitExceeded: Bool = false
    
    
    @Environment(\.dismiss) var dismiss
    
    init(projectVM: ProjectViewModel, project: ProjectModel) {
        self.projectVM = projectVM
        self.project = project
        _nameProjectTextField = State(initialValue: project.name ?? "")
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Renomear")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Nome do projeto aqui...", text: $nameProjectTextField)
                    .foregroundColor(.primary)
                    .font(.headline)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke( characterLimitExceeded ? .red : .linha, lineWidth: 1)
                            .animation(.easeInOut, value: characterLimitExceeded)
                    )
                
                if characterLimitExceeded {
                    Text("Você atingiu o máximo de caracteres (20)")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.leading, 4)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                if nameProjectTextField.count > 20 {
                    withAnimation {
                        characterLimitExceeded = true
                    }
                } else {
                    projectVM.updateProjectName(project: project, newName: nameProjectTextField, modelContext: modelContext)
                    dismiss()
                }
            }, label: {
                Text("Salvar")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
            .padding(.horizontal)
            .disabled(nameProjectTextField.isEmpty || characterLimitExceeded)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .onChange(of: nameProjectTextField) { oldValue, newValue in
            if newValue.count > 20 {
                withAnimation {
                    characterLimitExceeded = true
                }
            } else {
                withAnimation {
                    characterLimitExceeded = false
                }
            }
        }
    }
}

// Preview com um projeto de exemplo
#Preview {
    let previewProject = ProjectModel(name: "Projeto Teste")
    return EditNomeProjectView(projectVM: ProjectViewModel(), project: previewProject)
}
