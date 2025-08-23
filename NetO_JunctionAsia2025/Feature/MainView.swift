//
//  MainView.swift
//  NetO_JunctionAsia2025
//
//  Created by jiwon on 8/24/25.
//

import Lottie
import SwiftUI

enum Stage {
    case basic
    case bone
    case faility
    case final
}

struct MainView: View {

    @State private var currentStage: Stage = .basic
    @State private var progress = 0.0

    var body: some View {
        VStack {
            switch currentStage {
            case .basic:
                LottieLaunchView(
                    animationName: "dummylottie",
                    loopMode: .loop
                )
                .frame(width: 100)
            case .bone:
                Text("Bone Stage")
            case .faility:
                Text("Faility Stage")
            case .final:
                Text("Final Stage")
            }
            Text("\(progress)%")

        }
    }
}

#Preview {
    MainView()
}

struct LottieLaunchView: UIViewRepresentable {
    let animationName: String
    var loopMode: LottieLoopMode = .loop

    // UIKit뷰를 생성하고 초기화
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: animationName)
        // 로티가 화면에 맞춰서 표시되도록 설정
        view.contentMode = .scaleAspectFit
        view.loopMode = loopMode
        view.play()
        // 생성한 Lottie 뷰를 SwiftUI에 넘겨줌
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
