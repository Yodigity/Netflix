//
//  Resources.swift
//  Netflix
//
//  Created by Aaron Gokani on 29/05/2022.
//

import Foundation



extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
