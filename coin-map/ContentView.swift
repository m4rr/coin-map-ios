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

  @State private var selectedCurrency: [Currency] = []

  private var detailsIsNotEmpty: Bool {
    return !selectedCurrency.isEmpty || [
      selectedSubtitle, selectedPhone, selectedWebsite, selectedHours,
      ]
      .reduce(false, { $0 || !$1.isEmpty })
  }

  @State private var alert1: Bool = false
  @State private var alert2: Bool = false

  func paddingEdges(insets: EdgeInsets) -> Edge.Set {
    if insets.bottom.isZero {
      return .all
    } else {
      return [.top, .leading, .trailing]
    }
  }

//  var paddingEdgeSet: Edge.Set {
//    #if targetEnvironment(macCatalyst)
//    return .all
//    #else
//    if UIView().safeAreaInsets.bottom.isZero {
//      return .all
//    } else {
//      return [.top, .leading, .trailing]
//    }
//    #endif
//  }

  var body: some View {
    GeometryReader { g in
      ZStack {
        MapRepresentable(selected: self.$selected,
                         title: self.$selectedTitle,
                         subtitle: self.$selectedSubtitle,
                         phone: self.$selectedPhone,
                         website: self.$selectedWebsite,
                         hours: self.$selectedHours,
                         placeCurrencies: self.$selectedCurrency)
          .edgesIgnoringSafeArea(.all)

        VStack {

          // "i"
//          HStack {
//            Spacer()
//
//            Button(action: {
//              //
//            }) {
//              Text("i")
//                .font(.system(.headline, design: .monospaced))
//                .foregroundColor(.white)
//            }
//            .frame(width: 40, height: 40)
//            .background(LinearGradient(gradient: Gradient(colors: [.red, .blue]),
//                                       startPoint: .leading, endPoint: .trailing))
//              .cornerRadius(40)
//          }


          Spacer() // here we see the map

          if self.selected {
            VStack(spacing: 8) {

              if !self.selectedTitle.isEmpty {
                Text(self.selectedTitle)
                  .font(.system(.headline, design: .rounded))
                  .multilineTextAlignment(.center)
                  .frame(minWidth: 0, maxWidth: .infinity)
                  .foregroundColor(Color(UIColor.label))
              }

              if !self.selectedTitle.isEmpty && self.detailsIsNotEmpty {
                Divider()
              }

              if !self.selectedCurrency.isEmpty {
                Text(self.selectedCurrency.description)
                  .font(.system(.footnote, design: .monospaced))
              }

              if !self.selectedSubtitle.isEmpty {
                Text(self.selectedSubtitle)
                  .frame(minWidth: 0, maxWidth: .infinity)
                  .font(.subheadline)
                  .foregroundColor(Color(UIColor.label))
              }

              if !self.selectedPhone.isEmpty {
                Button(action: { self.alert1.toggle() }) {
                  Text(self.selectedPhone)
                }
                .popSheet(isPresented: self.$alert1, arrowEdge: .bottom) {
                  PopSheet(
                    title: Text("Call Number"),
                    message: Text(self.selectedPhone),
                    buttons: [
                      .default(Text("Call")) {
                        if let phone = URL(string: "tel:" + self.selectedPhone.trimmingCharacters(in: .whitespaces)) {
                          UIApplication.shared.open(phone, options: [:], completionHandler: nil)
                        }
                      },
                      .default(Text("Copy")) {
                        UIPasteboard.general.string = self.selectedPhone
                      },
                      .cancel(),
                  ])
                }
              }

              if !self.selectedWebsite.isEmpty {
                Button(action: { self.alert2.toggle() }) { Text(self.selectedWebsite) }
                  .popSheet(isPresented: self.$alert2, arrowEdge: .bottom) {
                    PopSheet(
                      title: Text("Open In Safari"),
                      message: Text(self.selectedWebsite),
                      buttons: [
                        .default(Text("Open"), action: {
                          if let url = URL(string: self.selectedWebsite) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                          }
                        }),
                        .default(Text("Copy")) {
                          UIPasteboard.general.string = self.selectedWebsite
                        },
                        .cancel(),
                      ]
                    )
                }
              }

              if !self.selectedHours.isEmpty {
                Text(self.selectedHours)
                  .foregroundColor(Color(UIColor.label))

              }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .transition(AnyTransition
            .opacity
            .animation(.easeOut(duration: 0.2))
            )
          }
        }
        .padding(self.paddingEdges(insets: g.safeAreaInsets))
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

