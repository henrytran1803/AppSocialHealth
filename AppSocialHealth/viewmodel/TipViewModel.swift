//
//  TipViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 26/7/24.
//

import Foundation

class TipViewModel: ObservableObject {
 
    func hasShownTip(for key: String) -> Bool {
        print(UserDefaults.standard.bool(forKey: key))
        return UserDefaults.standard.bool(forKey: key)
        
    }
    
    func markTipAsShown(for key: String) {
        UserDefaults.standard.set(true, forKey: key)
    }
    
}
