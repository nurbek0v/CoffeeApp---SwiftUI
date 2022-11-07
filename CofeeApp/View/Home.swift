//
//  home.swift
//  CofeeApp
//
//  Created by Kalchabek Nurbekov on 07.11.2022.
//

import SwiftUI

struct Home: View {
    //MARK: - Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentIndex: CGFloat = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            //MARK: - Scine Card Size is the Size of the Screen Width
            let cardSize = size.width
            
            //MARK: - Bottom Gradient Background
            LinearGradient(colors: [
                .clear,
                Color("brown").opacity(0.3),
                Color("brown").opacity(0.45),
                Color("brown")
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            
            //MARK: - Header View
            HeaderView()
            
            VStack(spacing: 0){
                ForEach(coffees){ coffee in
                    CoffeeView(coffee: coffee, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top,size.height - cardSize)
            .offset(y: offsetY)
            .offset(y: -currentIndex * cardSize)
        }
        .coordinateSpace(name: "SCROLL")
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    //MARK: - Slowing Down the Gesture
                    offsetY = value.translation.height * 0.4
                }).onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut){
                        if translation > 0 {
                            if currentIndex > 0 && translation > 250{
                                currentIndex -= 1
                            }
                        }else{
                            if currentIndex < CGFloat(coffees.count - 1) && -translation > 250{
                                currentIndex += 1
                            }
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .preferredColorScheme(.light)
    }
    @ViewBuilder
    func HeaderView() -> some View {
        VStack{
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                }
                Spacer()
                
                Button {
                    
                } label: {
                    Image("cart")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }

            }
            
            //Animated Slider
            GeometryReader{
                let size = $0.size
                
                HStack(spacing: 0){
                    ForEach(coffees) { coffee in
                        VStack(spacing: 15) {
                            Text(coffee.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            Text(coffee.price)
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: size.width)
                    }
                }
                .offset(x: currentIndex * -size.width)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8,blendDuration: 0.8), value: currentIndex)
                
            }
            .padding(.top, -5)
        }
        .padding(15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - Coffee View
struct CoffeeView: View {
    var coffee: Coffee
    var size: CGSize
    var body: some View {
        //If you want to decrease the size of image, then change it's card size
        let cardSize = size.width * 1
        // Since I want to show Three Max Cards on the Display
        let maxCadsDisplaySize = size.width * 4
        GeometryReader{proxy in
            let _size = proxy.size
            //MARK: - Scaling Animation
            //Current Card Offset
            let offset = proxy.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            let scale = offset <= 0 ? (offset / maxCadsDisplaySize) : 0
            let reducedScale = 1 + scale
            let currentCardScale = offset / cardSize
            
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: _size.width, height: _size.height)
            // To avoid warning
            //MARK: - Updating Anchor Based on the current card scale
                .scaleEffect(reducedScale < 0 ? 0.001 : reducedScale, anchor: .init(x: 0.5, y: 1 - (currentCardScale / 2)))
            //MARK: - When it's coming from bottom Animating the scale from alrge to actual size
                .scaleEffect(offset > 0 ? 1 + currentCardScale : 1, anchor: .top)
            //MARK: - To remove the excess next view using offset to move the view in real time
                .offset(y: offset > 0 ? currentCardScale * 200 : 0)
            //MARK: - Make it more compact
                .offset(y: currentCardScale * -130)
            
        }
        .frame(height: cardSize)
    }
}
