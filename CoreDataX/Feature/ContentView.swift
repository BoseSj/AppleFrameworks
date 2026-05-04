//
//  ContentView.swift
//  CoreDataX
//
//  Created by SJ Basak on 06/04/26.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab {
                MovieListVw()
            } label: {
                Label {
                    Text("SwiftUI")
                } icon: {
                    Image(systemName: "swift")
                }
            }
            
            Tab {
                MovieListView()
            } label: {
                Label {
                    Text("UIKit")
                } icon: {
                    Image(systemName: "swift")
                }
            }
        }
		.environment(\.managedObjectContext,
					  CDXStoreProvider.main.context)
    }
}

