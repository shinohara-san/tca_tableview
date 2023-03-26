//
//  BookList.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import ComposableArchitecture

struct BookList: ReducerProtocol {
    struct State: Equatable {
        var books: IdentifiedArrayOf<Book.State> = []
    }
    
    enum Action: Equatable {
        case book(id: Book.State.ID, action: Book.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
            .forEach(\.books, action: /Action.book) {
                Book()
            }
    }
}
