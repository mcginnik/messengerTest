//
//  KeyboardObserving.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import SwiftUI

struct KeyboardObserving: ViewModifier {
    
    @State var keyboardHeight: CGFloat = 0
    @State var keyboardAnimationDuration: Double = 0
    var onKeyboardChange: ((Notification) -> Void)?
    
    init(onKeyboardChange: ((Notification) -> Void)? = nil) {
        self.onKeyboardChange = onKeyboardChange ?? updateKeyboardHeight
    }
    
    func body(content: Content) -> some View {
        content
            .padding([.bottom], keyboardHeight)
            .edgesIgnoringSafeArea((keyboardHeight > 0) ? [.bottom] : [])
            .animation(.easeOut, value: keyboardAnimationDuration)
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                    .receive(on: RunLoop.main),
                perform: onKeyboardChange!
            )
    }
    
    func updateKeyboardHeight(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        keyboardAnimationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
                guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        if keyboardFrame.origin.y == UIScreen.main.bounds.height {
            keyboardHeight = 0
        } else {
            keyboardHeight = keyboardFrame.height
        }
    }
}

extension View {
    func keyboardObserving(onKeyboardChange: ((Notification) -> Void)? = nil) -> some View {
        self.modifier(KeyboardObserving(onKeyboardChange: onKeyboardChange))
    }
}
