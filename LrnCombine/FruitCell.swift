//
//  FruitCell.swift
//  LrnCombine
//
//  Created by Cepheus on 16/02/26.
//


import UIKit
import Combine


class FruitCell: UITableViewCell {
	
	let button: UIButton = {
		let btn = UIButton()
		btn.backgroundColor = .red
		
		let title = "Tap Here"
		btn.setTitle(title, for: .normal)
		btn.setTitleColor(.white, for: .normal)
		
		
		return btn
	}()
	
	let action = PassthroughSubject<String, Error>()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.button.translatesAutoresizingMaskIntoConstraints = false
		self.button.addTarget(self, action: #selector(didTapped),
							  for: .touchUpInside)
		
		self.contentView.addSubview(button)
	}
	
	@objc
	private func didTapped() {
		action.send("Button s been tapped")
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.button.frame = CGRect(
			x: 5, y: 5,
			width: self.contentView.frame.width - 5,
			height: self.contentView.frame.height - 5
		)
	}
	
	
	
}
