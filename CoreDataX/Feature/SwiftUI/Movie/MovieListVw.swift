//
//  MovieListVw.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//


import SwiftUI

struct MovieListVw: View {
    
    @State private var isLoading = false
    @StateObject private var viewModel = MovieModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movies) { movie in
                    Label {
                        Text(movie.name ?? "N//A")
                    } icon: {
                        if let poster = movie.poster {
                            Image(uiImage: poster)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .overlay(content: {
                if viewModel.movies.isEmpty {
                    ContentUnavailableView("No movies added", systemImage: "movieclapper")
                }
            })
            .overlay(content: {
                if isLoading {
                    ProgressView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Generate Movie") {
                        Task {
                            self.isLoading = true
                            defer { self.isLoading = false }
                            if let name = try? await MovieGenerator.main?.generateMovie() {
                                viewModel.storage.add(with: name)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
        }
    }
}
