//
//  ContentView.swift
//  RealGuessTheFlag
//
//  Created by Mi Gyeong Park on 2022/01/01.
//

import SwiftUI

struct WhiteText : View {
    var text : String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
    }
}

struct FrameVStack : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func frameVStackStyle() -> some View {
        modifier(FrameVStack())
    }
}

struct ContentView: View {
    @State private var showCorrect = false
    @State private var showingScore = false
    @State private var showingFinalAlert = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var countOfGame = 0
    private let questionCnt = 8
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                ], center: .top, startRadius: 300, endRadius: 700)
                .ignoresSafeArea()
            VStack (spacing: 15){
                VStack {
                    WhiteText(text: "Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                    WhiteText(text: countries[correctAnswer])
                        .font(.largeTitle.weight(.bold))
                    WhiteText(text: "Question : \(countOfGame) / \(questionCnt)")
                }
                ForEach(0..<3) { number in //0,1,2
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                            .overlay(showCorrectFlag(number: number) ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 6) : nil)
                    }
                    
                }
                HStack (spacing:20) {
                    Button("Skip", role: .destructive) {
                        askQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                    Button{
                        if !showCorrect {
                            showCorrect.toggle()
                        } else {
                            askQuestion()
                        }
                        
                    } label: {
                        Label(showCorrect ? "Next" : "Correct flag", systemImage : showCorrect ? "arrowshape.turn.up.right.circle" : "checkmark.circle.fill")
                    }
                    .foregroundColor(.black)
                    .buttonStyle(.bordered)
                    .fixedSize(horizontal: false, vertical: true)
                }
                
            }
//            .modifier(FrameVStack())
            .frameVStackStyle()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score) \\/ \(questionCnt)")
        }
        .alert(scoreTitle, isPresented: $showingFinalAlert) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(score) \\/ \(questionCnt)")
        }

    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])."
        }
        countOfGame += 1
        if countOfGame < questionCnt {
            showingScore = true
        } else {
            scoreTitle += " Do you want to restart the game?"
            showingFinalAlert = true
        }
    }
    
    func askQuestion() {
        if showCorrect {
            countOfGame += 1
            showCorrect = false
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        score = 0
        countOfGame = 0
        askQuestion()
    }
    
    func showCorrectFlag(number: Int) -> Bool {
        if showCorrect && number == correctAnswer {
            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
