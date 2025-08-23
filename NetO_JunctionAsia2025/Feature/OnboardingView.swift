//
//  OnboardingView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/23/25.
//

import SwiftUI

struct OnboardingView: View {
    let manager = GoogleSignInManager.shared

    @State private var checkbox = [false, false, false, false]

    private var allAgree: Bool { checkbox.allSatisfy { $0 } }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Have you prepared any land to build a house?")

            Toggle("Yes, I’ve prepared", isOn: $checkbox[0])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding()
            Text(
                "Do you have a blueprint that you received from the architect?"
            )

            Toggle("Yes, I have", isOn: $checkbox[1])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding()
            Text("Did you get a building permit?")

            Toggle("Yes, I did", isOn: $checkbox[2])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding()
            Text("Does the building have a floor area of less than 200m² ?")

            Toggle("Yes, I does", isOn: $checkbox[3])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding()

            Button {
                manager.showOnboarding = false
            } label: {
                Text("Go to next step")
                    .frame(maxWidth: .greatestFiniteMagnitude)
                    .padding(.vertical, 14)

            }
            .background(.orange)
            .foregroundStyle(.white)
            .disabled(!allAgree)
            .opacity(allAgree ? 1 : 0.5)
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    let style: Style

    func makeBody(configuration: Configuration) -> some View {
        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    Image(
                        systemName: configuration.isOn
                            ? "checkmark.\(style.sfSymbolName).fill"
                            : style.sfSymbolName
                    )
                    .imageScale(.large)
                    .foregroundColor(Color.orange)
                    configuration.label
                }
            }
        )
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }

    enum Style {
        case square, circle

        var sfSymbolName: String {
            switch self {
            case .square:
                return "square"
            case .circle:
                return "circle"
            }
        }
    }
}

#Preview {
    OnboardingView()
}
