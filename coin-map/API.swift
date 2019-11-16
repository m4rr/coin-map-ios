//
//  API.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import Foundation


class User: Codable {
  let id: String,
  email: String,
  emailConfirmed: Bool,
  firstName: String,
  lastName: String,
  avatarUrl: String,
  createdAt: Date,
  updatedAt: Date
}

class TokenResponse: Codable {
  let token: String, user: User
}



class UserResponse: Codable {
  let id: String,
  email: String,
  emailConfirmed: Bool,
  firstName: String,
  lastName: String,
  avatarUrl: String,
  createdAt: Date,
  updatedAt: Date
}
