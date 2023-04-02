//
//  BookListTests.swift
//  BookListTests
//
//  Created by shinohara.yuki.2250 on 2023/03/30.
//

import XCTest
import ComposableArchitecture
@testable import tca_tableview
import Combine

@MainActor
final class BookListTests: XCTestCase {

    func testFetchBooksSuccess() async {

        let books = [Book(id: UUID().uuidString, volumeInfo: .init(title: "book1")),
                     Book(id: UUID().uuidString, volumeInfo: .init(title: "book2")),
                     Book(id: UUID().uuidString, volumeInfo: .init(title: "book3"))]

        let store = TestStore(
            initialState: BookList.State(),
            reducer: BookList()
        ) {
            $0.bookClient.fetch = { books }
        }

        await store.send(.fetchBooks) {
            $0.isShowingIndicator = true
        }

        await store.receive(.setBooks(.success(books))) {
            $0.isShowingIndicator = false
            $0.books = books
        }
    }

    func testFetchBooksFailure() async {

        struct FetchError: Equatable, Error {}

        let store = TestStore(
            initialState: BookList.State(),
            reducer: BookList()
        ) {
            $0.bookClient.fetch = { throw FetchError() }
        }

        await store.send(.fetchBooks) {
            $0.isShowingIndicator = true
        }

        await store.receive(.setBooks(.failure(FetchError()))) {
            $0.isShowingIndicator = false
            $0.errorMessage = FetchError().localizedDescription
            $0.isShowingAlert = true
        }

        await store.send(.dismissAlert) {
            $0.isShowingAlert = false
        }
    }
}
