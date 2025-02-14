//
//  BrandingView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData



struct BrandingView: View {
    var currentProject: ProjectModel
    @StateObject private var colorVM = ColorViewModel()
    @StateObject private var fontVM = FontViewModel()
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            ColorPickerView(currentProject: currentProject, colorVM: colorVM, isEditing: $isEditing)
            Divider().padding(.top,10)
                .padding(.bottom,10)
            FontPickerView(currentProject: currentProject, fontVM: fontVM, isEditing: $isEditing)
            
        }
    }
}

//#Preview {
//    BrandingView()
//}
