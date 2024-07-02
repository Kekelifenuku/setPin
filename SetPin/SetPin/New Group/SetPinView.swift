//
//  SetPinView.swift
//  SetPin
//
//  Created by Fenuku kekeli on 7/1/24.
//

import SwiftUI

struct SetPinView: View {
    @State private var pin: [String] = ["", "", "", ""]
    @State private var currentPinIndex = 0
    @State private var pinSetSuccessfully = false
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                    .scaleEffect(pinSetSuccessfully ? 1.2 : 1.0)
                    .animation(pinSetSuccessfully ? .spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5) : .none)
                
                Text("Set PIN")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Please make up a PIN to protect the chat")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            HStack(spacing: 16) {
                ForEach(0..<4) { index in
                    PinBox(text: $pin[index], isCurrent: currentPinIndex == index)
                }
            }
            .padding(.vertical, 20)

            NumberPadView(pin: $pin, currentPinIndex: $currentPinIndex)
                .padding(.bottom, 20)

            Button(action: {
                // Handle Add PIN action
                pinSetSuccessfully = true
                showAlert = true
                print("PIN set: \(pin.joined())")
                // Reset after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    pinSetSuccessfully = false
                    pin = ["", "", "", ""]
                    currentPinIndex = 0
                }
            }) {
                Text("Add PIN")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(radius: 5)
            }
            .disabled(currentPinIndex < 4)
            .opacity(currentPinIndex < 4 ? 0.6 : 1.0)

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("PIN Set Successfully"), message: Text("Your PIN has been set successfully."), dismissButton: .default(Text("OK")))
        }
    }
}

struct PinBox: View {
    @Binding var text: String
    var isCurrent: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrent ? Color.orange : Color.white, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.1)))
                .frame(width: 60, height: 60)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                .scaleEffect(isCurrent ? 1.1 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5))
            
            Text(text)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct NumberPadView: View {
    @Binding var pin: [String]
    @Binding var currentPinIndex: Int

    let numbers = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(numbers, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { number in
                        Button(action: {
                            numberTapped(number)
                        }) {
                            Text(number)
                                .font(.title)
                                .frame(width: 80, height: 80)
                                .background(Color(.systemGray5))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .shadow(radius: 4)
                                .scaleEffect(number == "⌫" ? 1.0 : 0.9)
                                .animation(.spring())
                        }
                    }
                }
            }
        }
    }

    func numberTapped(_ number: String) {
        if number == "⌫" {
            if currentPinIndex > 0 {
                currentPinIndex -= 1
                pin[currentPinIndex] = ""
            }
        } else if !number.isEmpty && currentPinIndex < 4 {
            pin[currentPinIndex] = number
            currentPinIndex += 1
        }
    }
}

struct SetPinView_Previews: PreviewProvider {
    static var previews: some View {
        SetPinView()
    }
}
