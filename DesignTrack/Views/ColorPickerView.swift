//
//  ColorPickerView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData

struct ColorPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var colors: [ColorModel]
    var currentProject: ProjectModel
    
    @ObservedObject var colorVM: ColorViewModel
    @State private var selectedColor = Color.blue

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cores")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Color.accent)
                    .accessibilityLabel("Título: Cores")
            }
            
            HStack {
                
                Spacer()
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                
                Button("Adicionar") {
                    if let hex = selectedColor.toHex() {
                        withAnimation {
                            colorVM.addColor(hex: hex, project: currentProject, modelContext: modelContext)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(red: 0.8, green: 0, blue: 0.3))
                .foregroundStyle(.white)
                .cornerRadius(8)
                .accessibilityLabel("Botão para adicionar uma nova cor")
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if colors.isEmpty {
                        Text("Nenhuma cor adicionada ainda.")
                            .foregroundStyle(.gray)
                            .italic()
                            .accessibilityLabel("Aviso: Nenhuma cor adicionada ainda")
                    } else {
                        ForEach(colors) { color in
//                            if let hex = color.hex, let _ = Color(hex: hex) {
//                                //CardView(ColorModel: ColorModel, viewModel: viewModel)
//                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 5)
        }
    }
}

//#Preview {
//    ColorPickerView()
//}
