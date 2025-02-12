//
//  ProjectView.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 12/02/25.
//

import SwiftUI
import SwiftData

struct ProjectView: View {
    @ObservedObject var projectVM = ProjectViewModel()
    var currentProject: ProjectModel
    
    @State private var selectedTab: Int = 1
    
    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedTab) {
                Text("Logs").tag(1)
                Text("Projeto").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.pink)
            }
            
            if selectedTab == 1 {
                //LogProjectView(currentProject: currentProject)
            } else {
                EditProjectView(currentProject: currentProject)
            }
        }
        .navigationTitle(currentProject.name ?? "Sem Título")
    }
}


#Preview {
    ProjectView(currentProject: ProjectModel(name: "Linha"))
}
