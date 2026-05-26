//
//  MovieListVw.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//


import SwiftUI
import Combine


final class SearchText: ObservableObject {
	@Published var searchQuery = ""
	@Published private(set) var debouncedSearchQuery = ""
	
	init() {
		$searchQuery
			.debounce(for: 0.3, scheduler: DispatchQueue.main)
			.removeDuplicates()
			.assign(to: &$debouncedSearchQuery)
	}
}

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
    
    @State private var inAscending = true
    @StateObject private var search = SearchText()
	
    var body: some View {
        NavigationView {
			List {
                Toggle("Set ascending", isOn: $inAscending)
                ForEach(movies) { movie in
                    Label {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.name ?? "N//A")
                                .font(.system(size: 16))
                            Text("\(movie.rating)")
                                .font(.caption)
                                .tint(.gray)
                        }
                    } icon: {
                        if let poster = movie.poster {
                            Image(uiImage: poster)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
			.searchable(text: $search.searchQuery, prompt: Text("Search Movie"))
            .overlay(content: {
                if movies.isEmpty {
                    ContentUnavailableView("No movies added", systemImage: "movieclapper")
                        .foregroundStyle(.gray.gradient)
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
            .searchable(text: $search.searchQuery, prompt: "Search Movie")
        }
        .onChange(of: inAscending) {
            self.movies.sortDescriptors = [
                SortDescriptor(\.rating, order: inAscending ? .forward : .reverse)
            ]
        }
        .onChange(of: search.debouncedSearchQuery) {
            guard !search.debouncedSearchQuery.isEmpty else {
                self.movies.nsPredicate = nil
                return
            }
            self.movies.nsPredicate =  NSPredicate(
                format: "%K CONTAINS[cd] %@",
                argumentArray: [#keyPath(Movie.name), search.debouncedSearchQuery]
            )
        }
		.onChange(of: search.debouncedSearchQuery) {
			guard !search.debouncedSearchQuery.isEmpty else {
				self.movies.nsPredicate = nil
				return
			}
			self.movies.nsPredicate = NSPredicate(
				format: "%K CONTAINS[cd] %@",
				argumentArray: [#keyPath(Movie.name), search.debouncedSearchQuery]
			)
		}
        .onChange(of: inAscending) {
			self.movies.sortDescriptors = [
				SortDescriptor(\Movie.rating, order: inAscending ? .forward : .reverse)
			]
		}
    }
}
