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

    func testBooks() async {
        let store = TestStore(
            initialState: BookList.State(),
            reducer: BookList()
        )

        let books = [Book(id: UUID().uuidString, volumeInfo: .init(title: "book1")),
                     Book(id: UUID().uuidString, volumeInfo: .init(title: "book2")),
                     Book(id: UUID().uuidString, volumeInfo: .init(title: "book3"))]

        store.dependencies.bookClient.fetch = { books }

        await store.send(.fetchBooks) {
            $0.isShowingIndicator = true
        }

        await store.receive(.setBooks(.success(books))) {
            $0.isShowingIndicator = false
            $0.books = books
        }
    }
}
