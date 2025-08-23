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
            Text("Q. Have you prepared any land to build a house?").fontWeight(
                .black
            ).font(.system(size: 18))

            Toggle("Yes, I’ve prepared", isOn: $checkbox[0])
                .toggleStyle(CheckboxToggleStyle(style: .circle)).padding(
                    .top,
                    10
                )

                .fontWeight(.regular).font(.system(size: 14))
            Text(
                "Q. Do you have a blueprint that you received from the architect?"
            ).fontWeight(.black).font(.system(size: 18))
                .padding(.top, 25)

            Toggle("Yes, I have", isOn: $checkbox[1])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding().fontWeight(.regular).font(.system(size: 14)).padding(
                    .top,
                    10
                )
            Text("Q. Did you get a building permit?").fontWeight(.black).font(
                .system(size: 18)
            ).padding(.top, 25)

            Toggle("Yes, I did", isOn: $checkbox[2])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding().fontWeight(.regular).font(.system(size: 14)).padding(
                    .top,
                    10
                )
            Text("Q. Does the building have a floor area of less than 200m² ?")
                .fontWeight(.black).font(.system(size: 18)).padding(.top, 25)

            Toggle("Yes, I does", isOn: $checkbox[3])
                .toggleStyle(CheckboxToggleStyle(style: .circle))
                .padding()
                .fontWeight(.regular).font(.system(size: 14)).padding(.top, 10)
                .padding(.bottom, 30)
            Button {
                manager.showOnboarding = false
            } label: {
                Text("Go to next step")
                    .frame(maxWidth: 140)
                    .padding(.vertical, 14)
                    .fontWeight(.black)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .jaorange, .jayellow,
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            .disabled(!allAgree)
            .opacity(allAgree ? 1 : 0.5)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
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
                    .foregroundColor(.jaorange)
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
