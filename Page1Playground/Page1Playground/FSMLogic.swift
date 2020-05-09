//
//  FSMLogic.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 08/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit


class FSMLogic {
    
    enum StatesPG1 {
        case first
        case second
        case third
    }
    
    static func fsm1(from st1: StatesPG1, text: String) -> StatesPG1? {
        // - - - - - - -
        switch st1 {
        case .first:
            if text == "☎️" {
                return .second
            } else if text == "🔥" {
                return .third
            }
        case .second:
            if text == "🎱" {
                return .first
            }
        case .third:
            if text == "🎩" {
                return .third
            } else if text == "🐶" {
                return .second
            }
        default:
            return nil
        }
        return nil
    }
    
}
