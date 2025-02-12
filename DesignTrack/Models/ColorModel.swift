//
//  ColorItemModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import Foundation
import SwiftData

@Model
public class ColorModel {
    var hex: String
    
    var project: ProjectModel
    
    public init(hex: String, project: ProjectModel) {
        self.hex = hex
        self.project = project
    }
}
