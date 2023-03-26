//
//  BookDetail.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import ComposableArchitecture

struct BookDetail: ReducerProtocol {
    struct State: Equatable {
        var book: Book?
    }

    enum Action: Equatable {}

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {}
}

