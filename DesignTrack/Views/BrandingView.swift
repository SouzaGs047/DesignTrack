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
    //@StateObject private var fontViewModel: FontViewModel
    
    var body: some View {
        VStack {
            ColorPickerView(currentProject: currentProject, colorVM: colorVM)
            Divider()
            //FontPickerView(viewModel: fontViewModel)
            
        }
    }
}

//#Preview {
//    BrandingView()
//}
