//
//  MovieListVC.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//

import UIKit
import CoreData
import Combine


final class MovieListVC: UIViewController, UITableViewDelegate {
    
    private let table: UITableView = {
        let tbl = UITableView()
        tbl.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        return tbl
    }()
    private let movieButton: UIButton = {
        let bttn = UIButton(configuration: .borderedProminent())
        bttn.setTitle("Generate Movie", for: .normal)
        bttn.setTitleColor(.white, for: .normal)
        bttn.tintColor = .systemBlue
        
        return bttn
    }()
    private let loader = UIActivityIndicatorView()
    
    nonisolated private struct MovieModel: Hashable {
        var id = UUID()
        
        let name: String
    }
    
    private var movieList: [MovieModel] = [] {
        didSet { setNeedsUpdateProperties() }
    }
    private var section = "main"
    
    private var movieController: MovieProvider
    private var cancellable: Set<AnyCancellable> = .init()
    private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>!

    
    init() {
        self.movieController = .init(storage: CDXStoreProvider.main)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
}


private extension MovieListVC {
    func setUpDS() {
        self.dataSource = UITableViewDiffableDataSource(
            tableView: self.table,
            cellProvider: { [weak self] tableView, indexPath, movie in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                let movie = self?.movieController.resultController.object(at: indexPath)
                
                cell.textLabel?.text = movie?.name
                cell.imageView?.image = movie?.poster
                
                let removeButton = UIButton(type: .system)
                removeButton.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
                removeButton.tintColor = .systemRed
                removeButton.sizeToFit()
                removeButton.addAction(UIAction { [weak self] _ in
                    if let movie {
                        self?.movieController.remove(movie: movie)
                    }
                }, for: .touchUpInside)
                cell.accessoryView = removeButton
                
                cell.selectionStyle = .none
                cell.selectedBackgroundView = .none
                
                return cell
        })
    }
    func setUpView() {
        self.table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.table)
        self.table.delegate = self
        NSLayoutConstraint.activate([
            self.table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.setUpDS()
        self.movieController.$snapshot
            .sink { newSnapShot in
                if let newSnapShot {
                    self.dataSource.apply(newSnapShot)
                }
            }
            .store(in: &cancellable)
        
        self.movieButton.translatesAutoresizingMaskIntoConstraints = false
        self.movieButton.addAction(UIAction(handler: {  [weak self] _ in
            if let generator = MovieGenerator.main {
                Task {
                    self?.loader.startAnimating()
                    defer {
                        self?.loader.stopAnimating()
                    }
                    if let name = try? await generator.generateMovie() {
                        self?.movieController.add(with: name)
                    }
                }
            }
        }), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: movieButton)
        
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loader)
        self.loader.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
}


import SwiftUI

struct MovieListView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: MovieListVC())
    }
}
