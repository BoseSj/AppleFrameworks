//
//  EditDestination.swift
//  iTour
//
//  Created by SJ Basak on 10/08/26.
//

import SwiftUI
import SwiftData


struct EditDestination: View {
    
    @Bindable var destination: Destination
    @State private var newSight: String = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $destination.name)
            TextField("Desc", text: $destination.desc, axis: .vertical)
            DatePicker("Date", selection: $destination.date)
            
            Picker("Priority", selection: $destination.priority) {
                Text("Meh").tag(1)
                Text("Maybe").tag(2)
                Text("Must").tag(3)
            }
            .pickerStyle(.segmented)
            
            Section("Sights") {
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }
                
                HStack {
                    TextField("Add sight", text: $newSight)
                    Button("Add") {
                        self.addSight()
                    }
                }
            }
        }
        .navigationTitle("Update")
    }
}


private extension EditDestination {
    func addSight() {
        guard !newSight.isEmpty else { return }
        self.destination.sights.append(Sight(name: newSight))
        self.newSight = ""
    }
}
