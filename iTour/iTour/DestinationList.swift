//
//  DestinationList.swift
//  iTour
//
//  Created by SJ Basak on 10/08/26.
//

import SwiftUI
import SwiftData


struct DestinationList: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Destination.name)])
    var destinations: [Destination]
    
	init(sort: SortDescriptor<Destination>, searchText: String,
		 isShowingFutureOnly: Bool) {
		let now = Date.now
        _destinations = Query(filter: #Predicate {
			(searchText.isEmpty ||
			$0.name.localizedStandardContains(searchText)) &&
			(isShowingFutureOnly ? $0.date > now : true)
        }, sort: [sort])
    }
    
    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)
                        Text(destination.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                    }
                }
            }
            .onDelete(perform: delete)
        }
    }
}


private extension DestinationList {
    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            let data = destinations[index]
			modelContext.delete(data)
        }
        
        /// Current Behaviour
        /// Deleting Data
        /// Rerun the app
        /// Data restored
        /// Stopped running at XCode
        /// Launching the app
        /// Deleting the data
        /// Close and Relaunch the app
        /// Data is no more restored
        /// Solution: Need to manually save to experience in simulator
    }
}
