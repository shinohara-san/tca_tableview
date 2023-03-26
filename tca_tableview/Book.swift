//
//  Book.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import ComposableArchitecture
import UIKit

struct Book: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        var title = ""
    }

    enum Action: Equatable {}

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {}
}
