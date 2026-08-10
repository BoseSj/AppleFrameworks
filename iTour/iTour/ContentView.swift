//
//  ContentView.swift
//  iTour
//
//  Created by Cepheus on 10/08/26.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var sortOrder = SortDescriptor(\Destination.name)
    @State private var path: [Destination] = []
    @State private var searchText: String = ""
    @State private var isShowingFutureOnly = false
    
    var body: some View {
        NavigationStack(path: $path) {
			DestinationList(
				sort: sortOrder, searchText: searchText,
				isShowingFutureOnly: isShowingFutureOnly
			)
			.navigationDestination(for: Destination.self, destination: EditDestination.init)
			.searchable(text: $searchText)
			.toolbar {
				Button("Add Destination", systemImage: "plus") {
					self.addDestination()
				}
				Button("Future only", systemImage: "app.badge.clock.fill") {
					self.isShowingFutureOnly.toggle()
				}
				
				Menu("Sort", systemImage: "arrow.up.arrow.down") {
					Picker("Sort", selection: $sortOrder) {
						Text("Name")
							.tag(SortDescriptor(\Destination.name))
						Text("Date")
							.tag(SortDescriptor(\Destination.date))
						Text("Priority")
							.tag(SortDescriptor(\Destination.priority))
					}
					.pickerStyle(.inline)
				}
			}
		}
    }
}


private extension ContentView {
    func addDestination() {
        let destination = Destination()
        
        self.modelContext.insert(destination)
        self.path = [destination]
    }
}
