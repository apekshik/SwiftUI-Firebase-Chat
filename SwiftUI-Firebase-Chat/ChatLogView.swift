//
//  ChatLogView.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/20/22.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?

    @State var chatText = ""

    var body: some View {
        ZStack {
            messagesView
            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
            }
        }
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }

    private var messagesView: some View {
        ScrollView {
            ForEach(0..<20) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("FAKE MESSAGE FOR NOW")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }

            HStack{ Spacer() }
            .frame(height: 50)
        }
        .background(.black)

    }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(.white)
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $chatText)
                    .opacity(chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)

            Button {

            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.black)
    }


    private struct DescriptionPlaceholder: View {
       var body: some View {
           HStack {
               Text("Description")
                   .foregroundColor(.white)
                   .opacity(0.7)
                   .font(.system(size: 17))
                   .padding(.leading, 5)
                   .padding(.top, -4)
               Spacer()
           }
       }
       
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(chatUser: nil)
    }
}
