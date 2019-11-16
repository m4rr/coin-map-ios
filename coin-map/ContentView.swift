//
//  ContentView.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  var body: some View {

    MapKitMapView()
      .edgesIgnoringSafeArea(.all)
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
