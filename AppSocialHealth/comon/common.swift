//
//  common.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 20/7/24.
//

import Foundation
func getCurrentDateFullString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    let currentDate = Date()
    return dateFormatter.string(from: currentDate)
}
