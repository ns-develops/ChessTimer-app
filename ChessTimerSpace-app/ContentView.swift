//
//  ContentView.swift
//  ChessTimerSpace-app
//
//  Created by Natalie S on 2025-03-11.
//

import SwiftUI
import AVFoundation


struct ChessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()  // Gör ContentView till startvy
        }
    }
}

struct ContentView: View {
    var body: some View {
        NameEntryView()  // Din NameEntryView som huvudvy
    }
}

struct NameEntryView: View {
    @State private var playerOneName: String = ""
    @State private var playerTwoName: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("stars2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Enter Player Names")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()

                    VStack(spacing: 20) {
                        TextField("Enter Player 1's name", text: $playerOneName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(maxWidth: 300)
                            .multilineTextAlignment(.center)

                        TextField("Enter Player 2's name", text: $playerTwoName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(maxWidth: 300)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 40)

                    NavigationLink(
                        destination: ChessClockView(playerOneName: playerOneName, playerTwoName: playerTwoName),
                        label: {
                            Text("Start Game")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color(red: 0.0, green: 0.0, blue: 0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
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

    @State private var audioPlayer: AVAudioPlayer?

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
            playButtonClickSound()

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
            playButtonClickSound()
        }
    }

    private func playButtonClickSound() {
        if let soundURL = Bundle.main.url(forResource: "buttonClick", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
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
