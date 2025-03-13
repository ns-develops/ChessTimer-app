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

    @State var playerOneName: String
    @State var playerTwoName: String
    @State private var timeType: TimeType
    @State private var suddenDeathTime: Date

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(playerOneName: String, playerTwoName: String, timeType: TimeType, suddenDeathTime: Date) {
        self._playerOneName = State(initialValue: playerOneName)
        self._playerTwoName = State(initialValue: playerTwoName)
        self._timeType = State(initialValue: timeType)
        self._suddenDeathTime = State(initialValue: suddenDeathTime)

        if timeType == .bullet {
            self._playerOneTime = State(initialValue: 120) // 2 minutes
            self._playerTwoTime = State(initialValue: 120) // 2 minutes
        } else if timeType == .classical {
            self._playerOneTime = State(initialValue: 300) // 5 minutes
            self._playerTwoTime = State(initialValue: 300) // 5 minutes
        } else if timeType == .suddenDeath {
            self._playerOneTime = State(initialValue: Int(suddenDeathTime.timeIntervalSince1970)) // Set based on the sudden death time
            self._playerTwoTime = State(initialValue: Int(suddenDeathTime.timeIntervalSince1970)) // Same for player 2
        } else {
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
                    // Player One's Timer
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 5)
                        )
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

                    // Player Two's Timer
                    Circle()
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 5)
                        )
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
                if timeType != .freeGame {
                    if playerOneTimerActive {
                        if playerOneTime > 0 {
                            playerOneTime -= 1
                        } else {
                            gameEnded = true
                            winner = playerTwoName
                        }
                    }

                    if playerTwoTimerActive {
                        if playerTwoTime > 0 {
                            playerTwoTime -= 1
                        } else {
                            gameEnded = true
                            winner = playerOneName
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
    }

    private func toggleClock(for player: Player) {
        if gameEnded { return }

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
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    enum Player {
        case playerOne, playerTwo
    }
}

struct GIFImageView: UIViewRepresentable {
    var gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        if let gifData = NSDataAsset(name: gifName)?.data {
            let image = UIImage.gif(data: gifData)
            imageView.image = image
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

extension UIImage {
    class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        var images = [UIImage]()
        var duration: TimeInterval = 0.0

        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
            let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any]
            let gifProperties = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
            let delayTime = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime] as? Double ?? 0.1
            duration += delayTime
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}
