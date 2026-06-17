//
//  GridVc.swift
//  LrnCombine
//
//  Created by Cepheus on 07/06/26.
//

import Foundation
import UIKit
import Combine

class GridViewModel {
	@Published var fruits: [GridVc.Fruit] = [
		"Mango", "Apple", "Grape"
	].map { .init(name: $0) }
	
	func fetch() {
		Task {
			do {
				try await Task.sleep(for: .seconds(3))
				
				self.fruits.append(contentsOf: [
					"Orange", "Pinapple"
				].map { .init(name: $0) })
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}

final class GridVc: UIViewController {
	
	private var viewModel = GridViewModel()
	var cancellable = Set<AnyCancellable>()
	
	nonisolated struct Fruit: Identifiable, Equatable, Hashable {
		let id = UUID().uuidString
		let name: String
	}
	
	private lazy var grid = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 120, height: 65)
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		
		return view
	}()
	private var datasource: UICollectionViewDiffableDataSource<String, Fruit>!
	
	init(){
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupView()
		
		viewModel.$fruits
			.receive(on: DispatchQueue.main)
			.sink { [weak self] _ in
				self?.reloadView()
			}
			.store(in: &cancellable)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.fetch()
	}
}


private extension GridVc {
	func setupView() {
		self.grid.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.grid)
		self.grid.frame = self.view.bounds
		
		self.datasource = UICollectionViewDiffableDataSource(
			collectionView: self.grid,
			cellProvider: { collectionView, indexPath, itemIdentifier in
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
				
				let label = UILabel()
				label.translatesAutoresizingMaskIntoConstraints = false
				cell.contentView.addSubview(label)
				label.frame = cell.contentView.bounds
				label.text = itemIdentifier.name
				label.textAlignment = .center
				
				return cell
			})
	}
	func reloadView() {
		var snapshot = NSDiffableDataSourceSnapshot<String, Fruit>()
		snapshot.appendSections(["main"])
		snapshot.appendItems(viewModel.fruits)
		self.datasource.apply(snapshot)
	}
}
