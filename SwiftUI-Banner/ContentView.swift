//
//  ContentView.swift
//  SwiftUI-Banner
//
//  Created by Yusuke Miyata on 2021/12/12.
//

import SwiftUI

struct ContentView: View {
    @State private var isShow: Bool = false

    var body: some View {
        VStack {
            Button(action: { isShow = true }) {
                Text("バナー表示")
            }
        }
        .bannerVisible(with: $isShow)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func bannerVisible(with isShow: Binding<Bool>,
                       title: String = "TEST",
                       icon: String = "star.fill",
                       foregroundColor: Color = .white,
                       backgroundColor: Color = .red) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .modifier(Banner(isShow: isShow,
                             title: title,
                             icon: icon,
                             foregroundColor: foregroundColor,
                             backgroundColor: backgroundColor
                            )
            )
    }
}

struct Banner: ViewModifier {
    @Binding var isShow: Bool
    let title: String
    let icon: String
    let foregroundColor: Color
    let backgroundColor: Color

    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0

    func body(content: Content) -> some View {
        let asyncHide = DispatchWorkItem() { hide() }

        ZStack {
            content
            if isShow {
                VStack {
                    bannerView
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    asyncHide.cancel()
                    hide()
                }
                .onAppear {
                    show()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: asyncHide)
                }
                .offset(y: offset)
            }
        }
    }

    private var bannerView: some View {
        HStack {
            Image(systemName: icon)
                .opacity(opacity)
            Text(title).bold()
                .opacity(opacity)
            Spacer()
        }
        .foregroundColor(foregroundColor)
        .padding(12)
        .background(backgroundColor.opacity(opacity))
        .cornerRadius(8)
    }

    private func show() {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = 0
            withAnimation(.easeInOut(duration: 0.45)) {
                opacity = 0.75
            }
        }
    }

    private func hide() {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = -100
            withAnimation(.easeInOut(duration: 0.2)) {
                opacity = 0
                self.isShow = false
            }
        }
    }
}
