//
//  FontPickerView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import SwiftData

struct FontPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var fonts: [FontModel]
    var currentProject: ProjectModel
    
    @ObservedObject var fontVM: FontViewModel
    
    @State private var fontName = ""
    @State private var selectedCategory: String? = nil

    let categories = ["Títulos", "Texto Corrido", "Legenda", "Footnote"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Tipografia")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Color.accent)
                Spacer()
                Button("Adicionar") {
                    if !fontName.isEmpty, let category = selectedCategory {
                        withAnimation {
                            fontVM.addFont(nameFont: fontName, category: category, project: currentProject, modelContext: modelContext)
                        }
                        fontName = ""
                        selectedCategory = nil
                    }
                }
                .disabled(selectedCategory == nil)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(red: 0.8, green: 0, blue: 0.3))
                .foregroundStyle(.white)
                .cornerRadius(8)
            }

            HStack {
                TextField("Nome da fonte", text: $fontName)
                    .frame(width: 200, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory ?? "Selecione")
                            .foregroundColor(selectedCategory == nil ? .gray : .primary)
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.linha, lineWidth: 1)
                    )
                }
            }

            if fonts.isEmpty {
                Text("Nenhuma fonte adicionada ainda.")
                    .foregroundStyle(.gray)
                    .italic()
                   
            }
            List {
                ForEach(fonts, id: \.self) { font in
                    HStack {
                        Text(font.category)
                            .bold()
                        Spacer()
                        Text(font.nameFont)
                    }
                }
                .onDelete { indices in
                        for index in indices {
                            let fontToDelete = fonts[index]
                            fontVM.deleteFont(font: fontToDelete, modelContext: modelContext)
                        }
                    }
            }
            .listStyle(PlainListStyle())
            
            .scrollDisabled(true)
            
            .frame(height: CGFloat(fonts.count) * 60)
        }
        
    }
}

