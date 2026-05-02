//
//  HomeVC.swift
//  Combine
//
//  Created by Cepheus on 16/02/26.
//

import UIKit
import Combine


final class HomeVC: UIViewController {
	
	private let table: UITableView = {
		let tbl = UITableView()
		
		tbl.register(FruitCell.self, forCellReuseIdentifier: "cell")
		
		return tbl
	}()

	private var fruits: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.table.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.table)
		self.table.frame = self.view.bounds

		self.table.dataSource = self
		self.table.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.fetchFruits()
	}
	
	
	var observer: [AnyCancellable] = []
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
				self?.table.reloadData()
			})
			.store(in: &observer)
	}

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.fruits.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FruitCell else {
			preconditionFailure("Cell could not be generated")
		}
		
		cell.action
			.receive(on: DispatchQueue.main)
			.sink { completion in } receiveValue: { result in
				print("result: \(result)")
			}
			.store(in: &observer)
		
		return cell
	}
}
