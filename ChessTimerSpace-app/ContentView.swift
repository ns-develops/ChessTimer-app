//
//  ContentView.swift
//  ChessTimerSpace-app
//
//  Created by Natalie S on 2025-03-11.
//

import SwiftUI
import AVFoundation
import UIKit

enum TimeType {
    case classical, bullet, suddenDeath, freeGame
}

struct ContentView: View {
    var body: some View {
        TimeSelectionView()
    }
}

struct TimeSelectionView: View {
    @State private var selectedTimeType: TimeType = .classical

    private let buttonColor = Color(red: 0.0, green: 0.0, blue: 0.3)

    var body: some View {
        NavigationView {
            ZStack {
                Image("stars2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    GIFImageView(gifName: "atom")
                        .frame(width: 80, height: 80)
                        .padding(.bottom, 10)

                    LazyVGrid(columns: [GridItem(.fixed(120)), GridItem(.fixed(120))], spacing: 15) {
                        Button(action: {
                            selectedTimeType = .classical
                        }) {
                            Text("Classical (5 min)")
                                .font(.body)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(selectedTimeType == .classical ? buttonColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .bullet
                        }) {
                            Text("Bullet (2 min)")
                                .font(.body)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(selectedTimeType == .bullet ? buttonColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .suddenDeath
                        }) {
                            Text("Sudden Death")
                                .font(.body)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(selectedTimeType == .suddenDeath ? buttonColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTimeType = .freeGame
                        }) {
                            Text("Free Game")
                                .font(.body)
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(selectedTimeType == .freeGame ? buttonColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 15)

                    if selectedTimeType == .suddenDeath {
                        NavigationLink(
                            destination: SuddenDeathTimeSelectionView(),
                            label: {
                                Text("Set Sudden Death Time")
                                    .font(.title2)
                                    .padding()
                                    .frame(maxWidth: 150)
                                    .background(buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        )
                        .padding(.top, 15)
                    }

                    NavigationLink(
                        destination: NameEntryView(selectedTimeType: selectedTimeType, suddenDeathTime: Date()),
                        label: {
                            Text("Next")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(buttonColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    .padding(.top, 15)
                }
                .padding(.top, 40)
            }
        }
    }
}

struct SuddenDeathTimeSelectionView: View {
    @State private var suddenDeathTime: Date = Date()

    var body: some View {
        ZStack {
            Image("stars2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Set Sudden Death Time")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                // Time Picker for Sudden Death
                DatePicker("Choose Time", selection: $suddenDeathTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(width: 200, height: 200)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.top, 10)

                NavigationLink(
                    destination: NameEntryView(selectedTimeType: .suddenDeath, suddenDeathTime: suddenDeathTime),
                    label: {
                        Text("Next")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: 150)
                            .background(Color(red: 0.0, green: 0.0, blue: 0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                )
                .padding(.top, 15)
            }
            .padding(.top, 30)
            .padding(.horizontal, 15)
        }
    }
}

struct NameEntryView: View {
    @State private var playerOneName: String = ""
    @State private var playerTwoName: String = ""
    var selectedTimeType: TimeType
    var suddenDeathTime: Date

    var body: some View {
        ZStack {
            Image("stars2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Enter Player Names")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                VStack(spacing: 15) {
                    TextField("Enter Player 1's name", text: $playerOneName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: 250)
                        .multilineTextAlignment(.center)

                    TextField("Enter Player 2's name", text: $playerTwoName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: 250)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 30)

                NavigationLink(
                    destination: ChessClockView(playerOneName: playerOneName, playerTwoName: playerTwoName, timeType: selectedTimeType, suddenDeathTime: suddenDeathTime),
                    label: {
                        Text("Start Game")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: 150)
                            .background(Color(red: 0.0, green: 0.0, blue: 0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                )

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 30)
            .padding(.horizontal, 15)
        }
    }
}

struct ChessClockView: View {
    @State private var playerOneTime: Int
    @State private var playerTwoTime: Int
    @State private var isPlayerOneTurn: Bool = true
    @State private var playerOneTimerActive: Bool = false
    @State private var playerTwoTimerActive: Bool = false
    @State private var gameEnded: Bool = false
    @State private var winner: String? = nil
    @State private var alarmPlayed: Bool = false  // To avoid playing the alarm multiple times
    @State var playerOneName: String
    @State var playerTwoName: String
    @State private var timeType: TimeType
    @State private var suddenDeathTime: Date

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var audioPlayer: AVAudioPlayer?

    init(playerOneName: String, playerTwoName: String, timeType: TimeType, suddenDeathTime: Date) {
        self._playerOneName = State(initialValue: playerOneName)
        self._playerTwoName = State(initialValue: playerTwoName)
        self._timeType = State(initialValue: timeType)
        self._suddenDeathTime = State(initialValue: suddenDeathTime)

        if timeType == .bullet {
            self._playerOneTime = State(initialValue: 120)
            self._playerTwoTime = State(initialValue: 120)
        } else if timeType == .classical {
            self._playerOneTime = State(initialValue: 300)
            self._playerTwoTime = State(initialValue: 300)
        } else if timeType == .suddenDeath {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: suddenDeathTime)
            let minute = calendar.component(.minute, from: suddenDeathTime)
            let totalSeconds = (hour * 3600) + (minute * 60)
            self._playerOneTime = State(initialValue: totalSeconds)
            self._playerTwoTime = State(initialValue: totalSeconds)
        } else { // Free Game mode: initialize with 0 (time counts upwards)
            self._playerOneTime = State(initialValue: 0)
            self._playerTwoTime = State(initialValue: 0)
        }
    }

    var body: some View {
        ZStack {
            Image("space2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                if gameEnded {
                    Text("\(winner ?? "Game Over") has won!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    // Player 1 Circle
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .overlay(
                            VStack {
                                Text(playerOneName)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text(formatTime(timeRemaining: playerOneTime))
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                        )
                        .onTapGesture {
                            toggleClock(for: .playerOne)
                        }
                        .shadow(radius: 10)
                        .rotationEffect(Angle(degrees: 180))

                    Spacer()

                    // Player 2 Circle
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .overlay(
                            VStack {
                                Text(playerTwoName)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text(formatTime(timeRemaining: playerTwoTime))
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                        )
                        .onTapGesture {
                            toggleClock(for: .playerTwo)
                        }
                        .shadow(radius: 10)
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if !gameEnded {
                // Player One timer
                if playerOneTimerActive {
                    if timeType == .freeGame {
                        playerOneTime += 1  // Time counts upwards in Free Game mode
                    } else if playerOneTime > 0 {
                        playerOneTime -= 1  // Time counts down for other modes
                    }
                    checkForAlarm(for: .playerOne)
                } else if playerOneTime <= 0 && playerOneTimerActive {
                    gameEnded = true
                    winner = playerTwoName
                }

                // Player Two timer
                if playerTwoTimerActive {
                    if timeType == .freeGame {
                        playerTwoTime += 1  // Time counts upwards in Free Game mode
                    } else if playerTwoTime > 0 {
                        playerTwoTime -= 1  // Time counts down for other modes
                    }
                    checkForAlarm(for: .playerTwo)
                } else if playerTwoTime <= 0 && playerTwoTimerActive {
                    gameEnded = true
                    winner = playerOneName
                }
            }
        }
    }

    private func toggleClock(for player: Player) {
        if gameEnded { return }

        // Play sound when switching turns
        playSound()

        switch player {
        case .playerOne:
            playerOneTimerActive.toggle()
            playerTwoTimerActive.toggle()
        case .playerTwo:
            playerTwoTimerActive.toggle()
            playerOneTimerActive.toggle()
        }
    }

    private func formatTime(timeRemaining: Int) -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func playSound() {
        // Play sound only when switching turns
        guard let url = Bundle.main.url(forResource: "buttonClick", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    private func checkForAlarm(for player: Player) {
        // Prevent alarm from playing in Free Game mode
        if timeType == .freeGame {
            return
        }

        // Play alarm sound 3 seconds before the end of sudden death or other time-based modes
        let timeToCheck: Int
        if player == .playerOne {
            timeToCheck = playerOneTime
        } else {
            timeToCheck = playerTwoTime
        }

        if timeToCheck <= 3 && !alarmPlayed {
            playAlarm()
            alarmPlayed = true // Ensure alarm is played only once
        }
    }

    private func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarmClock", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing alarm sound: \(error.localizedDescription)")
        }
    }
}

enum Player {
    case playerOne, playerTwo
}

struct GIFImageView: View {
    let gifName: String

    var body: some View {
      
        Text(gifName)
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
}
