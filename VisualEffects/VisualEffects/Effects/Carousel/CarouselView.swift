//
//  CarouselView.swift
//  VisualEffects
//
//  Created by SJ Basak on 14/07/26.
//



import SwiftUI


struct CarouselView: View {
    
    private var images: [IdentifiableObj<Image>] {
        [
            Image(.img1), Image(.img2), Image(.img3),
            Image(.img4), Image(.img5), Image(.img6),
        ].map({ .init(obj: $0) })
    }
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height*0.5
            let cardWidth = proxy.size.width - 85
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(images) { image in
                        VStack {
                            ZStack {
                                ImageCard(image, width: cardWidth, height: height)
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        return content
                                            .offset(x: phase.value * -cardWidth)
        //                                    .rotationEffect(.degrees(phase.value*2.5))
        //                                    .offset(y: phase.isIdentity ? 0 : 28)
                                    }
                            }
                            .frame(width: cardWidth, height: height)
                            .clipShape(.rect(cornerRadius: 25))
                            
                            Text("Some Animal")
                                .font(.title)
                                .foregroundStyle(.black.gradient)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                }
                        }
                    }
                }.scrollTargetLayout()
            }
            /// Decided the scroll content's margin
//            .contentMargins(
//                (proxy.size.width - cardWidth)/2,
//                for: .scrollContent
//            )
//            .scrollTargetBehavior(.viewAligned)
        }
        .padding()
    }
}

/// UI
extension CarouselView {
    @ViewBuilder
    func ImageCard(_ image: IdentifiableObj<Image>, width: CGFloat, height: CGFloat) -> some View {
        image.obj
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
    }
}


