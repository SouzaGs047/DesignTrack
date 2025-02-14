//
//  ProjectModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import Foundation
import SwiftData

@Model
public class ProjectModel {
    var name: String?
    var image: Data?
    var type: String?
    var objective: String?
    var startDate: Date?
    var finalDate: Date?
    
    @Relationship(deleteRule: .cascade)
    var brandingColors: [ColorModel] = []
    
    @Relationship(deleteRule: .cascade)
    var brandingFonts: [FontModel] = []
    
    @Relationship(deleteRule: .cascade)
    var logs: [LogModel] = []
    
    public init(name: String? = nil, image: Data? = nil, type: String? = nil,
                objective: String? = nil, startDate: Date? = nil, finalDate: Date? = nil) {
        self.name = name
        self.image = image
        self.type = type
        self.objective = objective
        self.startDate = startDate
        self.finalDate = finalDate
    }
}
