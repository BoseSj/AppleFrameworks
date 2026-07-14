//
//  ContentView.swift
//  VisualEffects
//
//  Created by SJ Basak on 14/07/26.
//

import SwiftUI


struct CardView: View {
    
    private let color: Color
    init(color: Color = .blue) {
        self.color = color
    }
    
    private var height: CGFloat { UIScreen.main.bounds.height*0.6 }
    private var width: CGFloat { UIScreen.main.bounds.width - 50 }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(height: height)
            .frame(maxWidth: width)
            .foregroundStyle(color.gradient)
            .padding(12)
    }
}

struct IdentifiableObj<T> {
    var id = UUID()
    let obj: T
}

struct ContentView: View {
    
    private var colors: [IdentifiableObj<Color>] {
        [
            .red, .green, .blue, .cyan, .teal
        ].map({ .init(obj: $0) })
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(colors, id: \.id) { color in
                    CardView(color: color.obj)
                }
            }
        }
    }
}
