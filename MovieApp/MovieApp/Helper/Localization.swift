//
//  Localization.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation

class Localization {
    public static func localize(str: String, _ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(str, bundle: Bundle(for: Localization.self), comment: ""), args)
    }
}

extension String {
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized, arguments: arguments)
    }

    var localized: String{
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }
}
