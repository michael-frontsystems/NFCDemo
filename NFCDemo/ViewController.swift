//
//  ViewController.swift
//  NFCDemo
//
//  Created by Michael Redoble on 06/04/2018.
//  Copyright © 2018 Michael Redoble. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var nfcSession: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        fetchPokemon(id: 1)
    }
   
    @IBAction func scanPressed(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Parse the card's information
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
        }
        
        DispatchQueue.main.async {
            self.messageLabel.text = result
        }
    }
    
    //MARK: POKEMON
    func fetchPokemon(id: Int) {
        PokeManager.pokemon(id: id) { (pokemon) in
          self.messageLabel.text = pokemon.species.name
          PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
            self.image.image = image
          }
        }
    }
    
    func registerForNotifications() {
      NotificationCenter.default.addObserver(forName: .newPokemonFetched, object: nil, queue: nil) { (notification) in
          print("notification received")
          if let uInfo = notification.userInfo,
             let pokemon = uInfo["pokemon"] as? Pokemon {
            self.updateWithPokemon(pokemon)
          }
      }
    }
    
    func updateWithPokemon(_ pokemon: Pokemon) {
      messageLabel.text = pokemon.species.name
      PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
        self.image.image = image
      }
    }
}

