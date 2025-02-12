//
//  FontItemModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import Foundation
import SwiftData

@Model
public class FontModel {
    var nameFont: String
    var category: String
    
    var project: ProjectModel
    
    public init(nameFont: String, category: String, project: ProjectModel) {
        self.nameFont = nameFont
        self.category = category
        self.project = project
    }
}
