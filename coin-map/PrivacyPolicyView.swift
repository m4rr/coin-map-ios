//
//  PrivacyPolicyView.swift
//  coin-map
//
//  Created by Marat Say on 7/8/20.
//  Copyright © 2020 saytakov. All rights reserved.
//

import SwiftUI

private let btcAddress = "3Mt8QW6Q3pFU5663CB"+"TvqaupuN4V54z2Zb"
private let ppAddress = "saytakov.com/coin-map/privacy-policy/"
private let coinMapAddress = "coin-map.com"

struct PrivacyPolicyView: View {

  @Binding var detailsPresented: Bool

  var body: some View {

    ScrollView {

      VStack(alignment: .leading, spacing: 10) {

        Group {
          Text("How It Works")
            .font(.system(.title, design: .rounded))

          Text("All known Bitcoin accepting point of interest right on the map.")

          Text("Red dot is a POI; Blue dot is a cluster—has more that a point in there.")

          Divider()
        }

        Group {
          Text("Bitcoin World Map")
            .font(.system(.title, design: .rounded))

          Text("The original Bitcoin World Map is located on the link down below. I'm working to support all of theirs features in this app.")

          Button(coinMapAddress, action: {
            UIApplication.shared.open(URL(string: "https://"+coinMapAddress+"/")!, options: [:])
          })
          .font(.system(.body, design: .rounded))
          .frame(maxWidth: .infinity, alignment: .center)

          Divider()
        }

        Group {
          Text("Privacy Policy")
            .font(.system(.title, design: .rounded))

          Text("Bitcoin World Map (iOS & macOS) app is developed and supported by Marat Saytakov.")
          Text("Application or Marat doesn't collect or store any private data or user actions.")
          Text("If Marat change this Privacy Policy, he will notify you about it by publishing new version of document at this link:")

          Button(ppAddress) {
            UIApplication.shared
              .open(URL(string: "https://"+ppAddress)!, options: [:])
          }
          .font(.system(.body))
          .frame(maxWidth: .infinity, alignment: .center)

          Divider()
        }

        Group {

          Text("Disclaimer")
            .font(.system(.title, design: .rounded))

          Text("""
  There are no ads nor trackings in my projects:
  • most people don't like ads in apps;
  • trackers can expose private data to third parties.
  """)

          Text("If you want, you can use this:")

          HStack(alignment: .top) {
            Image("qr")
              .onTapGesture(count: 2) {
                debugPrint(btcAddress)
              }
              .onTapGesture {
                UIApplication.shared
                  .open(URL(string: "bitcoin:"+btcAddress)!, options: [:])
              }
              .onLongPressGesture {
                UIPasteboard.general
                  .string = btcAddress
              }

            Text("""
  Single Tap: open link
  Double Tap: save image
  Long Tap: copy text
  """)
              .font(.system(.footnote, design: .rounded))
              .padding(.all, 10)
          }
          .frame(maxWidth: .infinity, alignment: .center)

        }

        Spacer()

      }
      .font(.system(.body, design: .serif))
      .padding(.all, 10)
      .onTapGesture {
        detailsPresented.toggle()
      }

    }
    .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGray5),
                                                           Color(UIColor.systemGray6)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                  .edgesIgnoringSafeArea(.all))
  }

}

//struct PrivacyPolicyView_Previews: PreviewProvider {
//  static var previews: some View {
//    PrivacyPolicyView
//  }
//}
