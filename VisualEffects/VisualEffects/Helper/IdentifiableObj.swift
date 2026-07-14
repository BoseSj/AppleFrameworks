//
//  IdentifiableObj.swift
//  VisualEffects
//
//  Created by SJ Basak on 14/07/26.
//


import Foundation

struct IdentifiableObj<T>: Identifiable {
    var id = UUID()
    let obj: T
}