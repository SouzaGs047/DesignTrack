//
//  ColorViewModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData

class ColorViewModel: ObservableObject {
    
    func addColor(hex: String, project: ProjectModel, modelContext: ModelContext) {
        
        let newColor = ColorModel(hex: hex, project: project)
        modelContext.insert(newColor)
        
        project.brandingColors.append(newColor)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar cor: \(error)")
        }
        
    }
    
    func deleteColor(color: ColorModel, modelContext: ModelContext) {
        modelContext.delete(color)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar cor: \(error)")
        }
    }

}

