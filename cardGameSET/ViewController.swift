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
        }
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    
    @IBAction func startAgain(_ sender: UIButton) {
        game = Game()
        updateViewFromModel()
    }
    
    var game = Game()
    
    enum Feature {
        case symbol(String)
        case number(Int)
        case color(UIColor)
        case shade(Double?, CGFloat?)
    }
    
    var FeatureSpec: [String: Feature] = [
        "Sym0" : .symbol("●"),
        "Sym1" : .symbol("■"),
        "Sym2" : .symbol("▲"),
        "Num0" : .number(1),
        "Num1" : .number(2),
        "Num2" : .number(3),
        "Col0" : .color(.orange),
        "Col1" : .color(.blue),
        "Col2" : .color(.darkGray),
        "Sha0" : .shade(8.0, nil),
        "Sha1" : .shade(nil, 1.0),
        "Sha2" : .shade(nil, 0.4)
    ]
    
    func loadCardTitle(_ card: Card) -> NSAttributedString {
        var string = String()
        var attributes = [NSAttributedString.Key : Any]()
        var tempColorStorage: UIColor?
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.7
        
        func setFeatureValue(_ key: String) {
            if let value = FeatureSpec[key] {
                switch value {
                case .symbol(let symbol):
                    string = symbol
                case .number(let number):
                    string = Array(repeating: string, count: number).joined(separator: "\n")
                case .color(let color):
                    attributes[.foregroundColor] = color
                    tempColorStorage = color
                case .shade(let stroke, let alpha):
                    if stroke != nil {
                        attributes[.strokeWidth] = stroke
                    }
                    if alpha != nil {
                        if let color = tempColorStorage {
                            attributes[.foregroundColor] = color.withAlphaComponent(alpha!)
                        }
                    }
                }
            }
        }
        
        setFeatureValue("Sym\(card.symbol)")
        setFeatureValue("Num\(card.number)")
        setFeatureValue("Col\(card.color)")
        setFeatureValue("Sha\(card.shade)")
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            if let card = game.loadedCardsDict[index] {
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
//            else if game.keysWhereCardsNA.contains(index) {
//                button.setAttributedTitle(nil, for: UIControl.State.normal)
//                button.layer.borderWidth = 0
//                button.layer.borderColor = nil
//                button.layer.opacity = 0.0
//            }
            else {
                button.setAttributedTitle(nil, for: UIControl.State.normal)
                button.layer.borderWidth = 0
                button.layer.borderColor = nil
                button.layer.opacity = 0.0
            }
        }
    }
    
}
