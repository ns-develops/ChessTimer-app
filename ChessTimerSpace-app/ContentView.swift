//
//  ContentView.swift
//  ChessTimerSpace-app
//
//  Created by Natalie S on 2025-03-11.
//

import SwiftUI
import AVFoundation

enum TimeType {
    case classical, bullet, suddenDeath, freeGame
}

struct ContentView: View {
    var body: some View {
        TimeSelectionView()
    }
}

struct TimeSelectionView: View {
    @State private var selectedTimeType: TimeType = .classical // Default tidtyp är Classical

    var body: some View {
        NavigationView {
            ZStack {
                Image("stars2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Select Time Mode")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()

                    VStack(spacing: 15) {
                        Button(action: {
                            selectedTimeType = .classical
                        }) {
                            Text("Classical (5 min)")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimeType == .classical ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .bullet
                        }) {
                            Text("Bullet (2 min)")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimeType == .bullet ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .suddenDeath
                        }) {
                            Text("Sudden Death")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimeType == .suddenDeath ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .freeGame
                        }) {
                            Text("Free Game")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimeType == .freeGame ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    NavigationLink(
                        destination: NameEntryView(selectedTimeType: selectedTimeType),
                        label: {
                            Text("Next")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color(red: 0.0, green: 0.0, blue: 0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                }
            }
        }
    }
}

struct NameEntryView: View {
    @State private var playerOneName: String = ""
    @State private var playerTwoName: String = ""
    var selectedTimeType: TimeType

    var body: some View {
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
                    destination: ChessClockView(playerOneName: playerOneName, playerTwoName: playerTwoName, timeType: selectedTimeType),
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

struct ChessClockView: View {
    @State private var playerOneTime: Int
    @State private var playerTwoTime: Int
    @State private var isPlayerOneTurn: Bool = true
    @State private var playerOneTimerActive: Bool = false
    @State private var playerTwoTimerActive: Bool = false

    @State var playerOneName: String
    @State var playerTwoName: String
    @State private var timeType: TimeType
    private var audioPlayer: AVAudioPlayer?

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(playerOneName: String, playerTwoName: String, timeType: TimeType) {
        self._playerOneTime = State(initialValue: timeType == .bullet ? 120 : timeType == .classical ? 300 : 0)
        self._playerTwoTime = State(initialValue: timeType == .bullet ? 120 : timeType == .classical ? 300 : 0)
        self._playerOneName = State(initialValue: playerOneName)
        self._playerTwoName = State(initialValue: playerTwoName)
        self._timeType = State(initialValue: timeType)

        // Ladda ljudfilen korrekt
        if let soundURL = Bundle.main.url(forResource: "buttonClick", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay() // Förbereder ljudet för uppspelning
            } catch {
                print("Error loading sound file: \(error)")
            }
        }
    }

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
            if timeType != .freeGame {
                if playerOneTimerActive {
                    if playerOneTime > 0 {
                        playerOneTime -= 1
                    }
                }

                if playerTwoTimerActive {
                    if playerTwoTime > 0 {
                        playerTwoTime -= 1
                    }
                }
            } else {
                if playerOneTimerActive {
                    playerOneTime += 1
                }
                if playerTwoTimerActive {
                    playerTwoTime += 1
                }
            }
        }
    }

    private func toggleClock(for player: Player) {
        // Spela ljud varje gång en spelare trycker på sin klocka
        audioPlayer?.play()

        switch player {
        case .playerOne:
            if playerOneTimerActive {
                playerOneTimerActive = false
                playerTwoTimerActive = true
            } else {
                playerOneTimerActive = true
                playerTwoTimerActive = false
            }
        case .playerTwo:
            if playerTwoTimerActive {
                playerTwoTimerActive = false
                playerOneTimerActive = true
            } else {
                playerTwoTimerActive = true
                playerOneTimerActive = false
            }
        }
    }

    private func formatTime(timeRemaining: Int) -> String {
        if timeType == .freeGame {
            return String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
        }
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    enum Player {
        case playerOne, playerTwo
    }
}

#Preview {
    ContentView()
}
