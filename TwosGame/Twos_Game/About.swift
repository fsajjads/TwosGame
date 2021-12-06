//
//  About.swift
//  Twos_Game
//
//  Created by Fahim Sajjad on 10/19/21.
//

import SwiftUI

struct About: View {
    
    @GestureState var press = false
    @State var show = false
    var body: some View {
        
       
        ZStack {
            HStack{
            Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(show ? Color.black : Color.blue)
                        .mask(Circle())
                        .scaleEffect(press ? 2 : 1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6))
                        .gesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .updating($press) { currentState, gestureState, transaction in
                                    gestureState = currentState
                                }
                                .onEnded { value in
                                    show.toggle()
                                }
                        )
            Spacer()
            
            
                    if !show {
                        Text("View Image")
                            .padding()
                            .background(Capsule().stroke())
                    } else {
                        
                        Image("iribe")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .transition(.move(edge: .trailing))
                            .zIndex(1)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        show.toggle()
                    }
                }
        }
        
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
