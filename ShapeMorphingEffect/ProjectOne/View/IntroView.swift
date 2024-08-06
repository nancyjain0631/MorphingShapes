    //
    //  IntroView.swift
    //  ShapeMorphingEffect
    //
    //  Created by Nancy Jain on 05/08/24.
    //

import SwiftUI

struct IntroView: View {
    
        // View Properties
    @State var activePage: Page = .page1
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                Spacer()
                MorphicSymbolView(symbol: activePage.rawValue,
                                  config: Config(
                                    font: .system(size: 150, weight: .bold),
                                    frame: .init(width: 250, height: 200),
                                    radius: 30,
                                    foregroundColor: .white))
                Spacer()
                textContents(size: size)
                Spacer()
                indicatorView
                continueButton
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                headerView
            }
        }
        .background(
            Rectangle()
                .fill(.black.gradient)
                .ignoresSafeArea()
        )
    }
    
    
        //
    @ViewBuilder func textContents(size: CGSize) -> some View {
        VStack(spacing: 8) {
                // title
            viewTitle(size: size)
            
                // subtitle
            viewSubtitle(size: size)
        }
        .padding(.top, 16)
        .frame(width: size.width, alignment: .leading)
    }
    
        // title
    @ViewBuilder func viewTitle(size: CGSize) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Text(page.title)
                    .lineLimit(1)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .kerning(1.1)
                    .frame(width: size.width)
            }
        }
            // Sliding left or right based on the activePage
        .offset(x: -activePage.index * size.width)
        .animation(.smooth(duration: 0.7, extraBounce: 0.2), value: activePage)
    }
    
        // subtitle
    @ViewBuilder func viewSubtitle(size: CGSize) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Text(page.subTitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .frame(width: size.width)
                    .multilineTextAlignment(.center)
            }
        }
            // Sliding left or right based on the activePage
        .offset(x: -activePage.index * size.width)
            // aAdding a little delay
        .animation(.smooth(duration: 0.7, extraBounce: 0.3), value: activePage)
    }
    
        // Indicator view
    @ViewBuilder var indicatorView: some View {
        HStack(spacing: 8) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(.white.opacity(activePage == page ? 1 : 0.4))
                    .frame(width: activePage == page ? 25 : 8, height: 8)
                
            }
        }
        .animation(.smooth(duration: 0.5), value: activePage)
        .padding(.bottom)
    }
    
    @ViewBuilder var headerView: some View {
        HStack {
            Button {
                activePage = activePage.previousPage
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .fontWeight(.semibold)
                    .contentShape(.rect)
            }
            .opacity(activePage != .page1 ? 1 : 0)
            Spacer(minLength: 0)
            
            Button("Skip") {
                activePage = .page4
            }
            .fontWeight(.semibold)
            .opacity(activePage != .page4 ? 1 : 0)
            
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0), value: activePage)
        .padding()
        .foregroundStyle(.white)
    }
    
        // Continue button
    @ViewBuilder var continueButton: some View {
        Button(action: {
            activePage = activePage.nextPage
        }, label: {
            Text(activePage == .page4 ? "Login into PS App" : "Continue")
                .contentTransition(.identity)
                .foregroundStyle(.black)
                .padding(.vertical)
                .frame(maxWidth: activePage == .page4 ? 220 : 180)
                .background(.white, in: Capsule())
        })
        .padding(.bottom)
        .animation(.smooth(duration: 0.5), value: activePage)
    }
}

#Preview {
    ContentView()
}
