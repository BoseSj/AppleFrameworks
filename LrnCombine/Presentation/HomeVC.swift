//
//  HomeVC.swift
//  Combine
//
//  Created by Cepheus on 16/02/26.
//

import UIKit
import Combine


final class HomeVC: UIViewController, UITableViewDelegate {
	
	private let table: UITableView = {
		let tbl = UITableView()
		
		tbl.register(FruitCell.self, forCellReuseIdentifier: "cell")
		
		return tbl
	}()
	private var section = "main"
	private var dataSource: UITableViewDiffableDataSource<String, String>!
	private var fruits: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.fetchFruits()
	}
	
	
	var observer: Set<AnyCancellable> = []
	
}

/// UI
extension HomeVC {
	fileprivate func setUpView() {
		self.table.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.table)
		
		NSLayoutConstraint.activate([
			self.table.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			self.table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
		])
		self.table.register(FruitCell.self, forCellReuseIdentifier: "cell")
		self.table.delegate = self
		
		self.dataSource = UITableViewDiffableDataSource(
			tableView: self.table,
			cellProvider: { tableView, indexPath, itemIdentifier in
				let cell = self.table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FruitCell
				
				cell.action
					.receive(on: DispatchQueue.main)
					.sink { completion in } receiveValue: { result in
						print("result: \(result)")
					}
					.store(in: &self.observer)
				
				return cell
			})
	}
}

/// Data
extension HomeVC {
	private func fetchFruits() {
		APIService().fetchCompanies()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						print("Fetching Finished")
					case .failure(let err):
						print("Error: \(err.localizedDescription)")
				}
			}, receiveValue: { [weak self] result in
				print("Result: \(result)")
				
				self?.fruits = result
				self?.reload()
			})
			.store(in: &observer)
	}
	private func reload() {
		var snapshot = NSDiffableDataSourceSnapshot<String, String>()
		snapshot.appendSections([self.section])
		snapshot.appendItems(self.fruits)
		self.dataSource.apply(snapshot)
	}
}

extension Notification.Name {
	static let myNotification = Notification.Name("Some Notification")
}

func notify() {
	NotificationCenter.default
		.publisher(for: .myNotification)
		.sink { _ in
			print("Keyboard appeared")
		}
	
	NotificationCenter.default
		.post(Notification(name: .myNotification))
}
