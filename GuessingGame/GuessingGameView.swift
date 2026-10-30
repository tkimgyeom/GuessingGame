
//  GuessingGameView.swift
//  GuessingGame
//
//  WHAT THIS GAME DOES NOW
//  The app picks a secret whole number from 1 to 100.
//  You choose a guess with the buttons and click Guess.
//  The app tells you if your guess is right or not right,
//  and it counts your guesses. When you find the number,
//  you can play again.
//
//  WHAT IT DOES NOT DO YET
//  It does not tell you if your guess is too high or too low.
//  That part is up to you.
//

import SwiftUI

// The game's settings. They sit up here, outside the game,
// so that every part of the game below can use them.
// TRY: Change highestNumber to 10 for an easy game, or to 1000 for a hard one.
let lowestNumber: Int = 1
let highestNumber: Int = 100

// The game itself: what it remembers, what it shows on the screen,
// and what it does when you click a button.
struct GuessingGameView: View {

    // MARK: - Stored properties

    // Each @State variable is something the game remembers.
    // When one of them changes, the screen updates by itself.
    @State var score: Int = 0
    
    @State var gamesWon: Int = 0
    // The number the player is trying to find. The app picks it at random.
    @State var secretNumber: Int = Int.random(in: lowestNumber...highestNumber)

    // The guess the player is about to make. It starts in the middle.
    @State var guess: Int = (lowestNumber + highestNumber) / 2

    // How many guesses the player has made in this game.
    @State var guessCount: Int = 7
    
    // The message shown to the player, with a symbol and a colour to match it.
    @State var message: String = "Password is from \(lowestNumber) to \(highestNumber)."
    @State var messageSymbol: String = "questionmark.circle.fill"
    @State var messageColor: Color = Color.black

    // Becomes true when the player finds the secret number.
    @State var gameIsOver: Bool = false

    // MARK: - Computed properties
    
    
    var body: some View {
        VStack(spacing: 20) {

            // The title at the top of the screen.
            HStack {
                Image(systemName: "banknote")
                Text("Rob a Bank!")
            }
            .font(.custom("banknote", size: 65))
            .bold()
            .foregroundStyle(Color.black)
            // Shrink the title a little if it does not fit on one line.
            .lineLimit(1)
            .minimumScaleFactor(0.5)

            Spacer()

            // The message card: what the game has to say to you.
            VStack(spacing: 12) {
                Image(systemName: messageSymbol)
                    .font(.system(size: 60))
                    .foregroundStyle(messageColor)
                Text(message)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
        
            
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(messageColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Spacer()

            // The guess you are about to make, shown nice and big.
            // TRY: Change the size of this number from 96 to something else.
                Text("\(guess)")
                    .font(.system(size: 96, weight: .bold))
                    .monospacedDigit()
            
            
            // Four buttons to change the guess.
            // The code inside the braces runs when that button is clicked.
            HStack(spacing: 9) {
                Button("-10") {
                    lowerGuessByTen()
                }
                Button("-5") {
                    lowerGuessByFive()
                }
                Button("-1") {
                    lowerGuessByOne()
                }
                Button("+1") {
                    raiseGuessByOne()
                }
                Button("+5") {
                    raiseGuessByFive()
                }
                Button("+10") {
                    raiseGuessByTen()
                }
                .disabled(gameIsOver || guessCount < 2)
                
            }
            .buttonStyle(.bordered)
            .font(.title3)
            .bold()
            .monospacedDigit()
            .disabled(gameIsOver)

            // Show the Guess button while the game is on,
            // and the Play Again button once the number is found.
            HStack(spacing: 9) {
                if gameIsOver {
                    Button("Play Again", systemImage: "arrow.clockwise") {
                        startNewGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.green)
                } else {
                    Button("Guess", systemImage: "hand.point.up.left.fill") {
                        checkGuess()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button(action: {
                    askHackerHint()
                }) {
                    Label("Hint (-1)", systemImage: "laptopcomputer")
                        .font(.caption)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            HStack {
                Image(systemName: "heart.fill")
                Text("Remaining chances: \(guessCount)")
            }
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
            
            HStack {
                Image(systemName: "trophy.fill")
                Text("Success: \(gamesWon)")
            }
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
        }
        .padding(32)
        .font(.title2)
        .fontDesign(.rounded)
        .controlSize(.large)
        // TRY: Change indigo to another colour, such as teal, pink or orange.
        .tint(Color.black)
        // How big the game's window is on the Mac. It can be made taller or wider.
        .frame(minWidth: 420, minHeight: 640)
    }

    // MARK: - Functions
    func checkGuess() {
        if gameIsOver || guessCount <= 0 { return }
        
        guessCount -= 1
        
        if guess == secretNumber {
            gameIsOver = true
            gamesWon += 1
            message = "The vault is open! Grab the cash and run!"
            messageSymbol = "lock.open.fill"
            messageColor = .green
        } else if guessCount <= 0 {
            guessCount = 0
            gameIsOver = true
            message = "Out of tries! The police arrived and arrested you! (Code was: \(secretNumber))"
            messageSymbol = "light.beacon.max.fill"
            messageColor = .red
        } else if guess < secretNumber {
            message = "Partner: 'No!, It's Higher' (\(guessCount) chances left)"
            messageSymbol = "arrow.up.circle.fill"
            messageColor = .orange
        } else {
            message = "Partner: 'No, It's Lower' (\(guessCount) chances left)"
            messageSymbol = "arrow.down.circle.fill"
            messageColor = .blue
        }
    }

    func askHackerHint() {
        if gameIsOver || guessCount <= 0 { return }
        
        guessCount -= 1
        
        if guessCount <= 0 {
            guessCount = 0
            
            gameIsOver = true
            message = "We lost too much time checking the hint! The police arrived!"
            messageSymbol = "light.beacon.max.fill"
            messageColor = .red
        } else {
            if secretNumber % 2 == 0 {
                message = "Hacker: 'We lost some time! The passwod is [EVEN]! (\(guessCount) tries left)'"
            } else {
                message = "Hacker: 'We lost some time! The password is [ODD]! (\(guessCount) tries left)'"
            }
            messageSymbol = "laptopcomputer"
            messageColor = .purple
        }
    }

    func startNewGame() {
        secretNumber = Int.random(in: lowestNumber...highestNumber)
        guess = (lowestNumber + highestNumber) / 2
        guessCount = 7
        gameIsOver = false
        message = "Password is from \(lowestNumber) to \(highestNumber)."
        messageSymbol = "questionmark.circle.fill"
        messageColor = .black
    }
    // Changes the guess by the amount given, but keeps it inside the range.
    // A negative amount makes the guess smaller.
    func changeGuess(by amount: Int) {
        guess += amount
        if guess < lowestNumber {
            guess = lowestNumber
        }
        if guess > highestNumber {
            guess = highestNumber
        }
    }
    
    // Checks the player's guess against the secret number.

    // Makes the guess 10 smaller, but never smaller than the lowest number.
    func lowerGuessByTen() {
        guess -= 10
        if guess < lowestNumber {
            guess = lowestNumber
        }
    }
    
    func lowerGuessByFive() {
        guess -= 5
        if guess < lowestNumber {
            guess = lowestNumber
        }
    }

    // Makes the guess 1 smaller, but never smaller than the lowest number.
    func lowerGuessByOne() {
        guess -= 1
        if guess < lowestNumber {
            guess = lowestNumber
        }
    }

    // Makes the guess 1 bigger, but never bigger than the highest number.
    func raiseGuessByOne() {
        guess += 1
        if guess > highestNumber {
            guess = highestNumber
        }
    }
   
    func raiseGuessByFive() {
        guess += 5
        if guess > highestNumber {
            guess = highestNumber
        }
    }

    // Makes the guess 10 bigger, but never bigger than the highest number.
    func raiseGuessByTen() {
        guess += 10
        if guess > highestNumber {
            guess = highestNumber
        }
    }

    // Picks a new secret number and resets everything else.
}

#Preview {
    GuessingGameView()
}
