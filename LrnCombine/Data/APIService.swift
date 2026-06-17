//
//  APIService.swift
//  LrnCombine
//
//  Created by Cepheus on 16/02/26.
//



import UIKit
import Combine

class APIService {
	func fetchCompanies() -> Future<[String], Error> {
		return Future { promise in
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				promise(.success([
					"Mango", "Apple", "Banana", "Grape", "Guava"
				]))
			}
		}
	}
}
