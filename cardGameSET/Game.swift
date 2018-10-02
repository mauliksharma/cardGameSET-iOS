//
//  Game.swift
//  cardGameSET
//
//  Created by Maulik Sharma on 28/09/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation

class Game {
    
    var sortedCardsCollection = [Card]()
    var randomCardsCollection = [Card]()
    
    var score = 0
    
    init() {
        for sym in 0...2 {
            for num in 0...2 {
                for col in 0...2 {
                    for sha in 0...2 {
                        
                        let newCard = Card(symbol: sym, number: num, color: col, shade: sha, hashValue: Card.getUniqueHash())
                        sortedCardsCollection.append(newCard)
                    }
                }
            }
        }
        
        for _ in 0..<sortedCardsCollection.count {
            let randomIndex = Int(arc4random_uniform(UInt32(sortedCardsCollection.count)))
            randomCardsCollection.append(sortedCardsCollection.remove(at: randomIndex))
        }
        
        for index in 0...11 {
            loadNewCard(at: index)
        }
    }
    
    var loadedCardsDict = [Int: Card]()
    var keysWhereCardsNA = [Int]()
    var lastCardLoadedKey : Int = 11    //12 cards loaded with keys 0-11 on game creation
    
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
    
    func loadNewCard(at index: Int) {
        if !randomCardsCollection.isEmpty {
            loadedCardsDict[index] = randomCardsCollection.remove(at: 0)
        }
        else { //in case of no cards available for replacement
            keysWhereCardsNA.append(index)
            loadedCardsDict[index] = nil
        }
    }
    
    func replaceCards() {
        let positionsToReplaceAt = loadedCardsDict.keys.filter(){ matchedCards.contains(loadedCardsDict[$0]!) }
        for position in positionsToReplaceAt {
            loadNewCard(at: position)
        }
    }
    
    func deal3NewCards() {
        if !matchedCards.isEmpty {
            replaceCards()
            matchedCards.removeAll()
        }
        else {
            if lastCardLoadedKey < 24 { //should not exceed 24 cards at a time
                for offset in 1...3 {
                    loadNewCard(at: lastCardLoadedKey + offset)
                }
                lastCardLoadedKey += 3
            }
        }
    }
    
    func chooseCard(at key: Int) {
        if let cardToSelect = loadedCardsDict[key] {
            if !matchedCards.contains(cardToSelect) && !keysWhereCardsNA.contains(key){
                
                if !selectedCards.contains(cardToSelect) {  //selecting :-
                    if selectedCards.count == 2 {   //selecting 3rd card and testing for match
                        selectedCards.append(cardToSelect)
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
                            matchedCards.removeAll()
                        }
                        selectedCards = [cardToSelect]
                        
                    }
                    else {  //if no card or 1 card is selected
                        selectedCards.append(cardToSelect)
                    }
                }
                    
                else {  //deselecting :-
                    if selectedCards.count < 3 {
                        selectedCards = selectedCards.filter(){$0 != cardToSelect}
                        score -= 1
                    }
                }
            }
        }
    }
    
}
