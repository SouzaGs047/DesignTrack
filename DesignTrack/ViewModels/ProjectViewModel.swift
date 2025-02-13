//
//  ProjectViewModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData


class ProjectViewModel: ObservableObject {
        @Published var type: String = ""
        @Published var objective: String = ""
        @Published var startDate: Date = Date()
        @Published var finalDate: Date = Date()
        
    
    
    func addProject(name: String, modelContext: ModelContext) {
        let newProject = ProjectModel()
        newProject.name = name
        
        modelContext.insert(newProject)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar projeto: \(error)")
        }
    }
    
    func updateProject(
            project: ProjectModel,
            type: String,
            objective: String,
            startDate: Date,
            finalDate: Date,
            image: Data?,
            modelContext: ModelContext
        ) {
            project.type = type
            project.objective = objective
            project.startDate = startDate
            project.finalDate = finalDate
            project.image = image
            
            do {
                try modelContext.save()
                print("Projeto atualizado com sucesso!")
            } catch {
                print("Erro ao atualizar o projeto: \(error)")
            }
        }
    
    func updateProjectName(
            project: ProjectModel,
            newName: String,
            modelContext: ModelContext
        ) {
            project.name = newName
            
            do {
                try modelContext.save()
                print("Nome do projeto atualizado com sucesso!")
            } catch {
                print("Erro ao atualizar o nome do projeto: \(error)")
            }
        }
    
    func deleteProject(project: ProjectModel, modelContext: ModelContext) {
        modelContext.delete(project)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar o projeto: \(error)")
        }
    }
}

