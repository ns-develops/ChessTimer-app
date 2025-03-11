//
//  ContentView.swift
//  ChessTimerSpace-app
//
//  Created by Natalie S on 2025-03-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChessClockView()
    }
}

struct ChessClockView: View {
    @State private var playerOneTime: Int = 300 // 5 minuter
    @State private var playerTwoTime: Int = 300
    @State private var isPlayerOneTurn: Bool = true
    @State private var isPlayerOneClockActive: Bool = false
    @State private var isPlayerTwoClockActive: Bool = false
    @State private var playerOneTimerActive: Bool = false
    @State private var playerTwoTimerActive: Bool = false
    @State private var playerOneClockStopped = false
    @State private var playerTwoClockStopped = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Bakgrundsbild som täcker hela skärmen
            Image("space2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Första klockan (Player 1)
                Circle()
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .overlay(
                        VStack {
                            Text("Player 1")
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
                
                Spacer() // Skapar mellanrum mellan klockorna
                
                // Andra klockan (Player 2)
                Circle()
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .overlay(
                        VStack {
                            Text("Player 2")
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
    
    // Funktion för att växla mellan spelarna när klockan klickas
    private func toggleClock(for player: Player) {
        switch player {
        case .playerOne:
            if isPlayerOneClockActive {
                // Stoppar Player 1:s klocka och startar Player 2:s klocka
                playerOneTimerActive = false
                playerTwoTimerActive = true
                isPlayerOneClockActive = false
                isPlayerTwoClockActive = true
            } else {
                // Startar Player 1:s klocka och stoppar Player 2:s klocka
                playerOneTimerActive = true
                playerTwoTimerActive = false
                isPlayerOneClockActive = true
                isPlayerTwoClockActive = false
            }
        case .playerTwo:
            if isPlayerTwoClockActive {
                // Stoppar Player 2:s klocka och startar Player 1:s klocka
                playerTwoTimerActive = false
                playerOneTimerActive = true
                isPlayerOneClockActive = true
                isPlayerTwoClockActive = false
            } else {
                // Startar Player 2:s klocka och stoppar Player 1:s klocka
                playerTwoTimerActive = true
                playerOneTimerActive = false
                isPlayerOneClockActive = false
                isPlayerTwoClockActive = true
            }
        }
    }
    
    // Enum för att representera varje spelare
    enum Player {
        case playerOne, playerTwo
    }
    
    // Funktion för att formatera tiden till minuter och sekunder
    private func formatTime(timeRemaining: Int) -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
