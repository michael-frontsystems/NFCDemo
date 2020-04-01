//
//  Pokemon.swift
//  NFCDemo
//
//  Created by Michael Redoble on 01/04/2020.
//  Copyright © 2020 Michael Redoble. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
  struct Species: Codable {
    let name: String
  }
  
  struct Sprites: Codable {
    let backDefault: URL?
    let backShiny: URL?
    let frontDefault: URL?
    let frontShiny: URL?
    
    enum CodingKeys: String, CodingKey {
      case backDefault = "back_default"
      case backShiny = "back_shiny"
      case frontDefault = "front_default"
      case frontShiny = "front_shiny"
    }
  }
  
  let species: Species
  let sprites: Sprites
}
