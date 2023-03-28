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
        var isShowingIndicator = false
    }
    
    enum Action: Equatable {
        case fetchBooks
        case setBooks(TaskResult<[Book]>)
        case dismissAlert
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        enum SaveID {}
        switch action {
        case .fetchBooks:
            state.isShowingIndicator = true
            return .task {
                await .setBooks(
                    TaskResult { try await getData() }
                )
            }
            .cancellable(id: SaveID.self)
        case .setBooks(.success(let books)):
            state.isShowingIndicator = false
            state.books = books
            return .none
        case .setBooks(.failure(_)):
            state.isShowingIndicator = false
            state.isShowingAlert = true
            return .none
        case .dismissAlert:
            state.isShowingAlert = false
            return .none
        }
    }
}

func getData() async throws -> [Book] {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=quilting"
    guard let url = URL(string: urlString) else {
        throw APIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let (data, _) = try await URLSession.shared.data(for: request)
    do {
        let bookList = try JSONDecoder().decode(BookListItems.self, from: data)
        return bookList.items
    } catch {
        throw APIError.decodeError
    }
}

enum APIError: Error {
    case invalidURL, decodeError
}
