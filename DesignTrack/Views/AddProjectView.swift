//
//  AddProjectView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI

struct AddProjectView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var projectVM: ProjectViewModel
    
    @State var nameProjectTextField: String = ""
    
    @Environment(\.dismiss) var dismiss //Teste
    
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
            
            TextField("Nome do projeto aqui...", text: $nameProjectTextField)
                .foregroundColor(.primary)
                .font(.headline)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.linha, lineWidth: 1)
                )
                
                .padding(.horizontal)
            
            Button(action: {
                guard !nameProjectTextField.isEmpty else { return }
                projectVM.addProject(name: nameProjectTextField, modelContext: modelContext)
                dismiss()
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
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}



#Preview {
    AddProjectView(projectVM: ProjectViewModel())
}
