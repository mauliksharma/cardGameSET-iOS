//
//  Game.swift
//  cardGameSET
//
//  Created by Maulik Sharma on 28/09/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation

class Game {
    
    var score = 0
    
    var sortedDeck = [Card]()
    var shuffledDeck = [Card]()
    
    var loadedCards = [Card?]()
    
    init() {
        for sym in 0...2 {
            for num in 0...2 {
                for col in 0...2 {
                    for sha in 0...2 {
                        
                        let newCard = Card(symbol: sym, number: num, color: col, shade: sha, hashValue: Card.getUniqueHash())
                        sortedDeck.append(newCard)
                    }
                }
            }
        }
        
        for _ in 0..<sortedDeck.count {
            let randomIndex = Int(arc4random_uniform(UInt32(sortedDeck.count)))
            shuffledDeck.append(sortedDeck.remove(at: randomIndex))
        }
        
        for _ in 1...12 {
            loadedCards.append(getNewCard()!)
        }
    }
    
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    
    var symbolSet = Set<Int>()
    var numberSet = Set<Int>()
    var colorSet = Set<Int>()
    var shadeSet = Set<Int>()
    
    func clearSets() {
        symbolSet.removeAll()
        numberSet.removeAll()
        colorSet.removeAll()
        shadeSet.removeAll()
    }
    
    func getNewCard() -> Card? {
        return !shuffledDeck.isEmpty ? shuffledDeck.removeFirst() : nil
    }
    
    func replaceCards() {
        for matchedCard in matchedCards {
            if let index = loadedCards.index(of: matchedCard) {
                loadedCards[index] = getNewCard()
            }
        }
        matchedCards.removeAll()
    }
    
    func deal3NewCards() {
        if !matchedCards.isEmpty {
            replaceCards()
        }
        else if loadedCards.count <= 21 && !shuffledDeck.isEmpty {
            loadedCards.append(contentsOf: [getNewCard(), getNewCard(), getNewCard()])
        }
    }
    
    func chooseCard(at index: Int) {
        if let chosenCard = loadedCards[index] {
            if !matchedCards.contains(chosenCard) {
                if !selectedCards.contains(chosenCard) {  //selecting :-
                    if selectedCards.count == 2 {   //selecting 3rd card and testing for match
                        selectedCards.append(chosenCard)
                        for cardToMatch in selectedCards {
                            symbolSet.insert(cardToMatch.symbol)
                            numberSet.insert(cardToMatch.number)
                            colorSet.insert(cardToMatch.color)
                            shadeSet.insert(cardToMatch.shade)
                        }
                        if (symbolSet.count != 2) && (numberSet.count != 2) && (colorSet.count != 2) && (shadeSet.count != 2) {
                            for card in selectedCards {
                                matchedCards.append(card)
                            }
                            score += 3
                        }
                        else {
                            score -= 5
                        }
                        clearSets()
                    }
                    else if selectedCards.count == 3 {  //selecting fresh card after 3 cards tested for match
                        if !matchedCards.isEmpty {
                            replaceCards()
                        }
                        selectedCards = [chosenCard]
                        
                    }
                    else {  //if no card or 1 card is selected
                        selectedCards.append(chosenCard)
                    }
                }
                else {  //deselecting :-
                    if selectedCards.count < 3 {
                        selectedCards = selectedCards.filter(){$0 != chosenCard}
                        score -= 1
                    }
                }
            }
        }
    }
    
}
