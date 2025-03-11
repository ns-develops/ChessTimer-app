//
//  ContentView.swift
//  ChessTimerSpace-app
//
//  Created by Natalie S on 2025-03-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       
        NameEntryView()
    }
}

struct NameEntryView: View {
    @State private var playerOneName: String = ""
    @State private var playerTwoName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
             
                Image("stars")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Enter Player Names")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
              
                    TextField("Enter Player 1's name", text: $playerOneName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .background(Color.white)
                        .padding(.bottom, 30)
                    
                
                    TextField("Enter Player 2's name", text: $playerTwoName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .background(Color.white)
                        .padding(.bottom, 50)
                    
 
                    NavigationLink(
                        destination: ChessClockView(playerOneName: playerOneName, playerTwoName: playerTwoName),
                        label: {
                            Text("Start Game")
                                .font(.title)
                                      .padding()
                                      .background(Color(red: 0.0, green: 0.0, blue: 0.3))
                                      .foregroundColor(.white)
                                      .cornerRadius(10)
                        }
                    )
                    .padding(.bottom, 50)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
        }
    }
}

struct ChessClockView: View {
    @State private var playerOneTime: Int = 300 // 5 min
    @State private var playerTwoTime: Int = 300
    @State private var isPlayerOneTurn: Bool = true
    @State private var isPlayerOneClockActive: Bool = false
    @State private var isPlayerTwoClockActive: Bool = false
    @State private var playerOneTimerActive: Bool = false
    @State private var playerTwoTimerActive: Bool = false
    
    @State var playerOneName: String
    @State var playerTwoName: String
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
          
            Image("space2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
               
                Circle()
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .overlay(
                        VStack {
                            Text(playerOneName)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(formatTime(timeRemaining: playerOneTime))
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                    )
                    .onTapGesture {
                        toggleClock(for: .playerOne)
                    }
                    .shadow(radius: 10)
                    .rotationEffect(Angle(degrees: 180))
                
                Spacer()
                
          
                Circle()
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .overlay(
                        VStack {
                            Text(playerTwoName)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(formatTime(timeRemaining: playerTwoTime))
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                    )
                    .onTapGesture {
                        toggleClock(for: .playerTwo)
                    }
                    .shadow(radius: 10)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if playerOneTimerActive {
                if playerOneTime > 0 {
                    playerOneTime -= 1
                } else {
                    playerOneTimerActive = false
                }
            }
            
            if playerTwoTimerActive {
                if playerTwoTime > 0 {
                    playerTwoTime -= 1
                } else {
                    playerTwoTimerActive = false
                }
            }
        }
    }
    

    private func toggleClock(for player: Player) {
        switch player {
        case .playerOne:
            if isPlayerOneClockActive {
               
                playerOneTimerActive = false
                playerTwoTimerActive = true
                isPlayerOneClockActive = false
                isPlayerTwoClockActive = true
            } else {
             
                playerOneTimerActive = true
                playerTwoTimerActive = false
                isPlayerOneClockActive = true
                isPlayerTwoClockActive = false
            }
        case .playerTwo:
            if isPlayerTwoClockActive {
      
                playerTwoTimerActive = false
                playerOneTimerActive = true
                isPlayerOneClockActive = true
                isPlayerTwoClockActive = false
            } else {
                playerTwoTimerActive = true
                playerOneTimerActive = false
                isPlayerOneClockActive = false
                isPlayerTwoClockActive = true
            }
        }
    }
    

    enum Player {
        case playerOne, playerTwo
    }
    

    private func formatTime(timeRemaining: Int) -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
