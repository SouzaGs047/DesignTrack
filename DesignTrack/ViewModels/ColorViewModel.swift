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
        
//        if let existingColors = project.brandingColors as? Set<ColorModel>,
//           existingColors.contains(where: { $0.hex == hex }) {
//            print("Cor \(hex) já existe no projeto e não será adicionada.")
//            return
//        }
        
        let newColor = ColorModel(hex: hex, project: project)
        newColor.hex = hex
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

