//
//  ContentView.swift
//  BreathingFlower
//
//  Created by Alistair Nelson on 24/06/2022.
//

import SwiftUI

struct ErrorsView: View {
    @Binding var isMinimised: Bool
    @Binding var numberOfErrors : Double
    
    @Binding var animationDuration: Double
    
    @Binding var circleDiameter: Double
    
    var color = Color(UIColor.red).opacity(0.6)
    
    var colors: [Color] = [
        Color(UIColor.cyan).opacity(0.6),
        Color(UIColor.green).opacity(0.6),
        Color(UIColor.orange).opacity(0.6),
        Color(UIColor.blue).opacity(0.6),
        Color(UIColor.purple).opacity(0.6),
        Color(UIColor.red).opacity(0.6)]
    
    private var absolutePetalAngle: Double {
        return 360 / numberOfErrors
    }
    
    private var opacityPercentage: Double {
        let numberOfPetals = numberOfErrors.rounded(.down)
        let nextAngle = 360 / (numberOfPetals + 1)
        let currentAbsoluteAngle = 360 / numberOfPetals

        let totalTravel = currentAbsoluteAngle - nextAngle
        let currentProgress = absolutePetalAngle - nextAngle
        let percentage = currentProgress / totalTravel

        return 1 - percentage
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<Int(numberOfErrors), id: \.self) {err in
                Image(systemName: err % 2 == 0 ? "x.circle" : "x.circle.fill")
                    .font(.system(size: circleDiameter == 90 ? 65 : 20))
                    .frame(width: circleDiameter, height: circleDiameter)
                    .foregroundColor(colors[Int.random(in: 0..<6)])
                    .rotationEffect(.degrees(absolutePetalAngle * Double(err)), anchor: isMinimised ? .center : .leading)
                    .opacity(err == Int(numberOfErrors) ? opacityPercentage : 1)
            }
        }
        .offset(x: isMinimised ? 0 : circleDiameter / 2)
        .frame(width: circleDiameter * 2, height: circleDiameter * 2)
        .rotationEffect(.degrees(isMinimised ? -90 : 0))
        .scaleEffect(isMinimised ? 0.3 : 1)
        .animation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: animationDuration)
        .rotationEffect(.degrees(-60))
        .rotation3DEffect(.degrees(180), axis: (x: 0, y:1, z: 0))
        
    }
}

struct ContentView: View {
    @State private var numberOfErrors: Double = 6
    @State private var isMinimised = true
    @State private var animationDuration = 0.5
    
    @State private var breathDuration = 3.0
    
    @State private var smallDiameter: Double = 20
    @State private var largeDiameter: Double = 90
    
    let errorArray = ["E", "r", "r", "o", "r", "!"]
    var colors: [Color] = [
        Color(UIColor.cyan).opacity(0.6),
        Color(UIColor.green).opacity(0.6),
        Color(UIColor.orange).opacity(0.6),
        Color(UIColor.blue).opacity(0.6),
        Color(UIColor.purple).opacity(0.6),
        Color(UIColor.red).opacity(0.6)]
    
    var body: some View {
        VStack {
            ErrorsView(
                isMinimised: $isMinimised,
                numberOfErrors: $numberOfErrors,
                animationDuration: $animationDuration,
                circleDiameter: $largeDiameter
            )
                .frame(maxWidth: .infinity)
            HStack {
                Image(systemName: "x.circle.fill")
                Text("Error")

            }
                .font(.largeTitle)
                .foregroundColor(.red)
                .opacity(isMinimised ? 0 : 0.6)

            .animation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: isMinimised)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        
        VStack {
            ZStack {
                ForEach(0..<Int(numberOfErrors), id: \.self) {num in
                    ZStack {
                        Circle()
                            .fill(colors[Int.random(in: 0..<6)])
                            .frame(width: 65, height: 65, alignment: .center)
                            .offset(x: isMinimised ? CGFloat(num * 60) : 0)
                            
                        Text(errorArray[num])
                            .font(.system(size: 60))
                            .frame(width: 65, height: 65)
                            .offset(x: isMinimised ? CGFloat(num * 60) : 0)
                            .foregroundColor(colors[Int.random(in: 0..<6)])
                            .opacity(isMinimised ? 1 : 0)
                    }
                }
            }.animation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: isMinimised)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(.black)
        .onAppear {
            animationDuration = breathDuration
            isMinimised.toggle()
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
