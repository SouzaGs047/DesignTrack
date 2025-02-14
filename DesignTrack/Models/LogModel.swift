//
//  LogModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import Foundation
import SwiftData

@Model
public class LogModel {
    var date: Date
    var title: String
    var textContent: String?
    
    @Relationship(deleteRule: .cascade)
    var images: [LogImageModel] = []
    
    var project: ProjectModel
    
    public init(title: String, textContent: String? = nil,
                project: ProjectModel) {
        self.date = Date()
        self.title = title
        self.textContent = textContent
        self.project = project
    }
}
