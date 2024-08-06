//
//  MorphicSymbolView.swift
//  ShapeMorphingEffect
//
//  Created by Nancy Jain on 05/08/24.
//

import SwiftUI


// Custom Symbol morphic view
struct MorphicSymbolView: View {
    var symbol: String
    var config: Config
    
    // View properties
    @State var trigger: Bool = false
    @State var displayingSymbol: String = ""
    @State var nextSymbol: String = ""
    var body: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.4, color: config.foregroundColor))
            if let resolvedImage = context.resolveSymbol(id: 0) {
                context.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2), anchor: .center)
            }
        }symbols: {
            
            imageView
                .tag(0)
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) {(oldValue, newValue) in
            trigger.toggle()
            nextSymbol = newValue
        }
        .task {
            guard displayingSymbol == "" else { return }
            displayingSymbol = symbol
        }
    }
    
    @ViewBuilder var imageView: some View {
        KeyframeAnimator(initialValue: CGFloat.zero, trigger: trigger) { radius in
            Image(systemName: displayingSymbol == "" ? symbol : displayingSymbol)
                .font(config.font)
                // The radius is very important for morphing the symbol
                // will use Keyframe animator API to define the radius values for the morphing effect
                .blur(radius: radius)
                .frame(width: config.frame.width, height: config.frame.height)
                .onChange(of: radius) { newValue in
                    if newValue.rounded() == config.radius {
                            // the radius begins at zero and it progresses to the described radius before returning to 0.
                            // When the radius reaches the described radius value, it indicates that it in in the middle of the morph effect and when this occurs, we'll replace the symbol with the new symbol image resulting in a beautiful morphing effect
                        
                            // Animating symbol change
                        withAnimation(config.symbolAnimation) {
                            displayingSymbol = nextSymbol
                        }
                        
                    }
                }
                } keyframes: { _ in
                    CubicKeyframe(config.radius, duration: config.keyFrameDuration)
                    CubicKeyframe(0, duration: config.keyFrameDuration)
                }
            
        
    }
}

struct Config {
    var font: Font
    var frame: CGSize
    var radius: CGFloat
    var foregroundColor: Color
    var keyFrameDuration: CGFloat = 0.4
    var symbolAnimation: Animation = .smooth(duration: 0.5, extraBounce: 0)
}
#Preview {
    MorphicSymbolView(symbol: "gearshape.fill", config: Config(font: .system(size: 100, weight: .bold), frame: CGSize(width: 250, height: 200), radius: 15, foregroundColor: .black))
}
