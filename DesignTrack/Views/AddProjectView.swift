import SwiftUI

struct AddProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var projectVM: ProjectViewModel
    @State var nameProjectTextField: String = ""
    @State private var characterLimitExceeded: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Adicionar Projeto")
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
                    projectVM.addProject(name: nameProjectTextField, modelContext: modelContext)
                    dismiss()
                }
            }, label: {
                Text("Criar")
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

#Preview {
    AddProjectView(projectVM: ProjectViewModel())
}
