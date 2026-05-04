//
//  MovieListVw.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//


import SwiftUI

struct MovieListVw: View {
    
    @State private var isLoading = false
	
	@StateObject var storage = CDXStoreProvider.main
	
	@FetchRequest(fetchRequest: Movie.requestMoviesByPopularity)
	private var movies: FetchedResults<Movie>
	
	@SectionedFetchRequest(
		fetchRequest: Movie.requestMoviesByPopularity,
		sectionIdentifier: \.rating,
		animation: .bouncy
	)
	private var sections: SectionedFetchResults<Int64, Movie>
	
	
    var body: some View {
        NavigationStack {
			List {
				ForEach(self.sections) { section in
					Section {
						ForEach(section) { movie in
							Text(movie.name ?? "N\\A")
						}
					} header: {
						Text(
							"Movie Rating: \(section.id)"
						)
					}
				}
//                ForEach(movies) { movie in
//                    Label {
//                        Text(movie.name ?? "N//A")
//                    } icon: {
//                        if let poster = movie.poster {
//                            Image(uiImage: poster)
//                                .foregroundStyle(.blue)
//                        }
//                    }
//                }
            }
            .overlay(content: {
                if movies.isEmpty {
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
								storage.add(with: name)
							} else {
								storage.add(with: "Movie \(UUID().uuidString.prefix(4))")
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
