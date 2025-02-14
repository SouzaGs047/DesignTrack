//
//  FontViewModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import SwiftData

class FontViewModel: ObservableObject {
    
    func addFont(nameFont: String, category: String, project: ProjectModel, modelContext: ModelContext) {
        
        let newFont = FontModel(nameFont: nameFont, category: category, project: project)
        modelContext.insert(newFont)
        
        project.brandingFonts.append(newFont)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar fonte: \(error)")
        }
    }
    
    func deleteFont(font: FontModel, modelContext: ModelContext) {
        modelContext.delete(font)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar font: \(error)")
        }
    }
}
