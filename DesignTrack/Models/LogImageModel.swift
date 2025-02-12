//
//  LogImageModel.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import Foundation
import SwiftData

@Model
public class LogImageModel {
    var imageData: Data
    var log: LogModel
    
    public init(imageData: Data, log: LogModel) {
        self.imageData = imageData
        self.log = log
    }
}
