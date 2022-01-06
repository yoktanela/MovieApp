//
//  BehaviorRelayExtension.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 6.01.2022.
//

import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
