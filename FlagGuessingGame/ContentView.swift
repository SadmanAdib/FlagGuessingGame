//
//  ContentView.swift
//  FlagGuessingGame
//
//  Created by Sadman Adib on 2/19/22.
//

import SwiftUI

//creating custom ViewModifier with View extension for a title
struct Title: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        
    }
    
}

extension View{
    func titleStyle() -> some View{
        modifier(Title())
    }
}

//for replacing Image view with FlagImage view
struct FlagImage: View{
    var name: String
    var body: some View{
        Image(name)
            .renderingMode(.original).clipShape(Capsule()).shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var rotationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var showNumber = 0
    @State private var showFinalScore = false
    @State private var questionNumber = 0
    
    @State private var countries = ["afghanistan", "albania", "algeria", "andorra", "angola", "antigua", "argentina", "bahamas", "bahrain", "bangladesh"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animate = false
    @State private var tappedNumber = 0
    
    var body: some View {
        
        ZStack{
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            
            VStack( spacing: 30){
                VStack{
                    Text("Flag Guessing Game").titleStyle()
                    Text("Tap the correct flag of").foregroundColor(.white).font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3){ number in
                    Button{
                        flagTapped(number)
                        withAnimation {
                            rotationAmount[number] += 360
                        }
                      
                    } label: {
                        FlagImage(name: countries[number])
                            .rotation3DEffect(.degrees(rotationAmount[number]), axis: (x: 0, y: 1, z: 0))
                            .opacity(animate ? (number == tappedNumber ? 1 : 0.25) : 1)
                            .scaleEffect(animate ? (number == tappedNumber ? 1 : 0.5) : 1)
                            .animation(.default, value: animate)
//                        Image(countries[number])
//                            .renderingMode(.original).clipShape(Capsule()).shadow(radius: 5)
                    }
                    
                }

            }
        }.alert(scoreTitle, isPresented: $showingScore){
            Button("continue", action: askQuestion)
        }message:{
            if scoreTitle == "Wrong!"{
                Text("That's the flag of \(countries[showNumber])")
            }
            else{
                Text("Your score is \(score)")
            }
        }.alert(scoreTitle, isPresented: $showFinalScore){
            Button("Restart", action: resetGame)
        }message:{
            Text("Your final score is \(score + 1) out of 8")
        }
    }
    
    func resetGame(){
        score = 0
        questionNumber = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animate = false
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animate = false
    }
    
    func flagTapped(_ number : Int) {
        if number == correctAnswer && questionNumber != 7{
            scoreTitle = "Correct!"
            score+=1
            showingScore = true
        }
        else if number != correctAnswer && questionNumber != 7{
            scoreTitle = "Wrong!"
            showNumber = number
            showingScore = true
        }
        else{
            showingScore = false
            showFinalScore = true
        }
        
        tappedNumber = number
        questionNumber+=1
        animate = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
