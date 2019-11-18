//
//  ContentView.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @State private var selected: Bool = false
  @State private var selectedTitle: String = ""
  @State private var selectedSubtitle: String = ""
  @State private var selectedPhone: String = ""
  @State private var selectedWebsite: String = ""
  @State private var selectedHours: String = ""

  @State private var alert1: Bool = false
  @State private var alert2: Bool = false

  var body: some View {
    ZStack {
      MapKitMapView(selected: $selected,
                    title: $selectedTitle,
                    subtitle: $selectedSubtitle,
                    phone: $selectedPhone,
                    website: $selectedWebsite,
                    hours: $selectedHours)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Spacer() // here we see the map

        if selected {
          VStack(spacing: 8) {
            Text(selectedTitle)
              .font(.headline)
              .frame(minWidth: 0, maxWidth: .infinity)

            Divider()

            if !selectedSubtitle.isEmpty {
              Text(selectedSubtitle)
                .font(.subheadline)
            }

            if !selectedPhone.isEmpty {
              Button(action: {
                self.alert1.toggle()
              }, label: {
                Text(selectedPhone)
              })
                .actionSheet(isPresented: $alert1) {
                  ActionSheet(title: Text("Call Number"),
                              message: Text(self.selectedPhone),
                              buttons: [
                                Alert.Button.default(Text("Call")) {
                                  if let phone = URL(string: "tel:" + self.selectedPhone.trimmingCharacters(in: .whitespaces)) {
                                    UIApplication.shared.open(phone, options: [:], completionHandler: nil)
                                  }
                                },
                                Alert.Button.default(Text("Copy")) {
                                  UIPasteboard.general.string = self.selectedPhone
                                },
                                Alert.Button.cancel(),
                    ]
                  )
              }
            }

            if !selectedWebsite.isEmpty {
              Button(action: {
                self.alert2.toggle()
              }, label: {
                Text(selectedWebsite)
              })
                .actionSheet(isPresented: $alert2) {
                  ActionSheet(title: Text("Open In Safari"),
                              message: Text(self.selectedWebsite),
                              buttons: [
                                Alert.Button.default(Text("Open"), action: {
                                  if let url = URL(string: self.selectedWebsite) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                  }
                                }),
                                Alert.Button.default(Text("Copy")) {
                                  UIPasteboard.general.string = self.selectedWebsite
                                },
                                Alert.Button.cancel(),
                    ]
                  )
              }
            }

            if !selectedHours.isEmpty {
              Text(selectedHours)
            }
          }
          .padding()
          .background(Color.white)
          .cornerRadius(10)
        }
      }
      .padding([.top, .leading, .trailing])
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

