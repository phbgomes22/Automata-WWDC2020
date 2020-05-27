//
//  FSMLogic.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 08/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit


public class FSMLogic {
    
    public enum StatesPG1 {
        case first
        case second
        case third
    }
    
    
    public enum StatesPG2 {
        case first
        case second
        case third
        case forth
    }
    
    public enum StatesPG3 {
        case first
        case second
        case third
        case forth
    }
    
    static func fsm1(from st1: StatesPG1, text: String) -> StatesPG1? {
        // - - - - - - -
        switch st1 {
        case .first:
            if text == "🤖" {
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
        }
        return nil
    }
    
    
    static func fsm2(from st1: StatesPG2, bool: Bool) -> StatesPG2? {
        // - - - - - - -
        switch st1 {
        case .first:
            if bool {
                return .second
            } else {
                return .third
            }
        case .second:
            if bool {
                return .third
            } else {
                return .first
            }
        case .third:
            if bool {
                return .forth
            } else {
                return .second
            }
        case .forth:
            if bool {
                return .first
            } else {
                return .third
            }
        }
    }
    
    static func fsm3(from st1: StatesPG3) -> StatesPG3? {
        
        switch st1 {
        case .first:
            return .second
        case .second:
            return .third
        case .third:
            return .forth
        case .forth:
            return nil
        }
        
    }
}
