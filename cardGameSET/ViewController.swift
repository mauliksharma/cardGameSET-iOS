//
//  ViewController.swift
//  cardGameSET
//
//  Created by Maulik Sharma on 27/09/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            updateViewFromModel()
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardButtonIndex =  cardButtons.index(of: sender) {
            game.chooseCard(at: cardButtonIndex)
            updateViewFromModel()
            scoreLabel.text = String(game.score)
        }
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        game = Game()
        updateViewFromModel()
        scoreLabel.text = String(game.score)
    }
    
    var game = Game()
    
    let shapes = ["●", "■", "▲"]
    let colors : [UIColor] = [.orange, .blue, .darkGray]
    
    func loadCardTitle(_ card: Card) -> NSAttributedString {
        let string = Array(repeating: shapes[card.shape], count: card.number + 1).joined(separator: "\n")
        var attributes = [NSAttributedString.Key : Any]()
        let color = colors[card.color]
        switch card.shade {
        case 0:
            attributes[.strokeWidth] = 8.0
            attributes[.strokeColor] = color
        case 1:
            attributes[.foregroundColor] = color.withAlphaComponent(0.4)
        case 2:
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
        default:
            break
        }
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            if game.loadedCards.indices.contains(index), let card = game.loadedCards[index] {
                button.setAttributedTitle(loadCardTitle(card), for: UIControl.State.normal)
                button.layer.opacity = 1.0
                if game.matchedCards.contains(card) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.red.cgColor
                }
                else if game.selectedCards.contains(card) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.blue.cgColor
                }
                else {
                    button.layer.borderWidth = 0
                    button.layer.borderColor = nil
                }
            }
            else {
                button.setAttributedTitle(nil, for: UIControl.State.normal)
                button.layer.borderWidth = 0
                button.layer.borderColor = nil
                button.layer.opacity = 0.0
            }
        }
    }
    
}
