//
//  BookList.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import ComposableArchitecture
import Combine
import Foundation

struct BookList: ReducerProtocol {
    struct State: Equatable {
        var books: [Book] = []
        var isShowingAlert = false
        var errorMessage = ""
        var isShowingIndicator = false
    }
    
    enum Action: Equatable {
        case fetchBooks
        case setBooks(TaskResult<[Book]>)
        case dismissAlert
    }

    @Dependency(\.bookClient) var bookClient

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        enum SaveID {}
        switch action {
        case .fetchBooks:
            state.isShowingIndicator = true
            return .task {
                await .setBooks(
                    TaskResult { try await bookClient.fetch() }
                )
            }
            .cancellable(id: SaveID.self)
        case .setBooks(.success(let books)):
            state.isShowingIndicator = false
            state.books = books
            return .none
        case .setBooks(.failure(let error)):
            state.isShowingIndicator = false
            state.errorMessage = error.localizedDescription
            state.isShowingAlert = true
            return .none
        case .dismissAlert:
            state.isShowingAlert = false
            return .none
        }
    }
}
