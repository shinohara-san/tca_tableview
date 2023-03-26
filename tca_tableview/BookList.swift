//
//  BookList.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import ComposableArchitecture

struct BookList: ReducerProtocol {
    struct State: Equatable {
        var books: [Book] = []
    }
    
    enum Action: Equatable {
        case fetchBooks
        case setBooks(books: [Book])
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchBooks:
            let books = [Book(title: "ブルーロック"), Book(title: "呪術廻戦"), Book(title: "ワンピース")]
            return .send(.setBooks(books: books))
        case .setBooks(books: let books):
            state.books = books
            return .none
        }
    }
}
