//
//  ContentView.swift
//  VisualEffects
//
//  Created by SJ Basak on 14/07/26.
//

import SwiftUI


struct ContentView: View {
    
    private var items: [IdentifiableObj<String>] {
        [
            "Apple", "Mango", "Banana",
            "Jackfruit", "Chilli", "Grape",
            "Papaya", "Cherry", "Guava",
            "Papaya", "Cherry", "Guava",
            "Papaya", "Cherry", "Guava",
            "Papaya", "Cherry", "Guava",
        ].map({ .init(obj: $0) })
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(items.indices, id: \.self) { index in
                    // ForEach(items) { item in
                    
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.blue.gradient)
                        .overlay {
                            Text(items[index].obj)
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.4)
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
    func calculatedOffset(minY: CGFloat, index: Int) -> CGFloat {
        let spacing: CGFloat = 20

        // Where this card should stop.
        let stopPosition = CGFloat(index) * spacing

        // Once the card reaches stopPosition,
        // keep it there.
        return max(0, stopPosition - minY)
    }
    func offsetForPhase(_ phase: ScrollTransitionPhase) -> CGFloat {
        guard phase.value < 0 else { return 0 }
        
        return phase.value * -116 * 0.85
    }
}

/// UI
extension ContentView {
    
}
