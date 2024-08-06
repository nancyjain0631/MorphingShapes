    //
    //  MorphingView.swift
    //  ShapeMorphingEffect
    //
    //  Created by Nancy Jain on 05/08/24.
    //

import SwiftUI

struct MorphingView: View {
        // MARK: View Properties
    @State var currentImage: CustomShape = .cloud
    @State var pickerImage: CustomShape = .cloud
    @State var turnOffImageMorph: Bool = false
    @State var blurRadius: CGFloat = 0
    @State var animateMorph: Bool = false
    
    var body: some View {
        VStack {
            // MARK: Image Morph is simple
            // Simply Mask the Canvas Shape as Image Mask
            
            GeometryReader { proxy in
                let size = proxy.size
                Image("LadyImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: 40.0)
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .clipped()
                    .overlay {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImageMorph ? 1 : 0)
                    }
                    .mask {
                        // MARK: Morphing shapes with the help of canvas and filters
                        Canvas { context, size in
                            // MARK: Morphing Filters
                            // MARK: For more Morph shape link change this min value
                            context.addFilter(.alphaThreshold(min: 0.5))
                            
                            //MARK: This value plays major role in the morphing animation
                            // For Reverse Animation
                            // Until 20 -> it will be like 0-1
                            // After 20 till 40 -> it will be like 1-0
                            context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                            // MARK: Draw Inside Layer
                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    ctx.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2), anchor: .center)
                                }
                            }
                        } symbols: {
                            // MARK: Giving images with ID
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        
                        // MARK: Animation will not work in the Canvas
                        // We can use timeline view for those animations
                        // But here we'll use Timer to acheieve the same effect
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect(), perform: { _ in
                            if animateMorph {
                                if blurRadius <= 40 {
                                        // This is animation speed
                                    blurRadius += 0.5
                                    if blurRadius.rounded() == 20 {
                                            // MARK: Change of next image goes here
                                        currentImage = pickerImage
                                    }
                                }
                                if blurRadius.rounded() == 40 {
                                        //MARK: End animation and reset the blur radius to 0
                                    animateMorph = false
                                    blurRadius = 0
                                }
                                
                            }
                        })
                    }
            }
            .frame(height: 400)
            VStack {
                
                // MARK: Segmented Picker
                Picker("", selection: $pickerImage) {
                    ForEach(CustomShape.allCases, id: \.rawValue) { shape in
                        Image(systemName: shape.rawValue)
                            .tag(shape)
                    }
                }
                .pickerStyle(.segmented)
                
                // MARK: Avoid tap until current animation is finished
                .overlay {
                    Rectangle()
                        .fill(.primary)
                        .opacity(animateMorph ? 0.05 : 0)
                }
                
                .padding()
                // MARK: Whenever picker image changes
                // Morphing into new shape
                .onChange(of: pickerImage) { newValue in
                    animateMorph = true
                }
                Toggle("Turn Off Image Morph", isOn: $turnOffImageMorph)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Slider(value: $blurRadius, in: 0...40)
            }
        }
        .offset(y: -50)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ResolvedImage: View {
    @Binding var currentImage: CustomShape
    
    var body: some View {
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 1.0), value: currentImage)
            .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
