//
//  KeyboardInputAccessoryView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import SwiftUI

struct KeyboardInputAccessoryView: View {
    
    @Binding var text: String
    @State var image: UIImage? = nil
    @State var showImagePicker: Bool = false
    @FocusState var focusedField: Bool
    private var height: CGFloat
    let sendButtonWasTapped:  (UIImage?) -> Void

    
    init(text: Binding<String>,
         height: CGFloat = 40,
         focusedField: FocusState<Bool>? = nil,
         sendButtonWasTapped: @escaping (UIImage?) -> Void){
        self._text = text
        
        if let focusedField = focusedField {
            self._focusedField = focusedField
        }
        
        self.height = height
        self.sendButtonWasTapped = sendButtonWasTapped
    }
    
    var textField: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
            }
            TextField(StringConstants.textInputPlaceholder, text: $text)
                .padding(.horizontal)
                .frame(height: height)
                .background(Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .focused($focusedField)
                .keyboardType(.default)
        }
        

    }
    
    var sendButton: some View {
        Button {
            self.sendButtonWasTapped(image)
            image = nil
        } label: {
            Image(systemName: ImageConstants.sendButton)
                .foregroundColor(.white)
                .frame(width: height, height: height)
                .background(
                    Circle()
                        .foregroundColor(text.isEmpty ? .gray : .blue)
                )
        }
        .disabled(text.isEmpty)
    }
    
    var imageButton: some View {
        Button {
            showImagePicker.toggle()
        } label: {
            Image(systemName: ImageConstants.imageButton)
                .foregroundColor(.white)
                .frame(width: height, height: height)
                .background(
                    Circle()
                        .foregroundColor(.blue)
                )
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                imageButton
                textField
                sendButton
            }
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        .padding()
        .background(.thickMaterial)
    }

}

struct KeyboardInputAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardInputAccessoryView(text: .constant("Test"),
                                   sendButtonWasTapped: {_ in})
    }
}
