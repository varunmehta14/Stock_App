//
//  SuccessSheetView.swift
//  stock-app
//
//  Created by Varun Mehta on 29/04/24.
//

import SwiftUI

struct SuccessSheetView: View {
    let message: String
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all) // Background color
            VStack {
                Spacer()
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(message)")
                    .padding()
                Spacer()
                HStack{
                    
                    Button(action: {
                        isPresented = false // Open the trade sheet when the button is tapped
                    }) {
                        Text("Done")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding()
                            .frame(width: 350)
                            .background(Color.white)
                            .cornerRadius(30)// Customized green trade
                    }
                 
                }.padding()
            }
//            .padding()
        }
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct SuccessSheetView_Previews: PreviewProvider {
    static var previews: some View {
        
        SuccessSheetView(message: "Apple Inc",isPresented:.constant(true))
                         // Provide a value for currentPrice here
//                           ) // Provide a value for cashBalance here)
    }
}
