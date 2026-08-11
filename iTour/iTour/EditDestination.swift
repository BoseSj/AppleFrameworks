//
//  EditDestination.swift
//  iTour
//
//  Created by SJ Basak on 10/08/26.
//

import SwiftUI
import SwiftData


struct EditDestination: View {
    
	@Environment(\.modelContext) private var modelContext
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
				.onDelete(perform: deleteSight)
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
	func deleteSight(_ indexSet: IndexSet) {
		self.destination.sights.remove(atOffsets: indexSet)
	}
	
    func addSight() {
        let trimmedName = newSight.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        self.destination.sights.append(Sight(name: trimmedName))
        self.newSight = ""
    }

    func deleteSight(_ indexSet: IndexSet) {
        /// Now if we had added separate container for here we need to take care both the references
        /// 1. that Destination is holding
        /// 2. that actual Sight
//          let sightsToDelete = indexSet.map { self.destination.sights[$0] }

        self.destination.sights.remove(atOffsets: indexSet)

//        for sight in sightsToDelete {
//            modelContext.delete(sight)
//        }
    }
}
