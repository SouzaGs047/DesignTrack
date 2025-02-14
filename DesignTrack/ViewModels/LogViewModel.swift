//
//  LogViewModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 13/02/25.
//

import SwiftUI
import SwiftData

class LogViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var textContent: String = ""
    @Published var images: [Data] = []

    func addLog(
        project: ProjectModel,
        title: String,
        textContent: String,
        imagesData: [Data],
        modelContext: ModelContext) {
            
        let newLog = LogModel(title: title, project: project)
        newLog.textContent = textContent
        modelContext.insert(newLog)
        
            
        for imageData in imagesData {
            let logImage = LogImageModel(imageData: imageData, log: newLog)
            modelContext.insert(logImage)
            newLog.images.append(logImage)
        }

        project.logs.append(newLog)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar log: \(error)")
        }
    }
    
    func updateLog(
        log: LogModel,
        title: String,
        textContent: String,
        imagesData: [Data],
        modelContext: ModelContext) {
            
        log.title = title
        log.textContent = textContent
        
        for oldImage in log.images {
            modelContext.delete(oldImage)
        }
        log.images.removeAll()

            
        for imageData in imagesData {
            let newImage = LogImageModel(imageData: imageData, log: log)
            modelContext.insert(newImage)
            log.images.append(newImage)
        }

        do {
            try modelContext.save()
            print("Log atualizado com sucesso!")
        } catch {
            print("Erro ao atualizar o log: \(error)")
        }
    }

    
    func deleteLog(log: LogModel, modelContext: ModelContext) {
        modelContext.delete(log)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar log: \(error)")
        }
    }
}

