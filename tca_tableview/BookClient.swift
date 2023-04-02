//
//  BookClient.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/04/02.
//

import ComposableArchitecture
import Foundation

struct BookClient {
  var fetch: @Sendable () async throws -> [Book]
}

extension DependencyValues {
  var bookClient: BookClient {
    get { self[BookClient.self] }
    set { self[BookClient.self] = newValue }
  }
}

extension BookClient: DependencyKey {
  /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
  /// Typically this live implementation of the dependency would live in its own module so that the
  /// main feature doesn't need to compile it.
  static let liveValue = Self(
    fetch: {
//      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "https://www.googleapis.com/books/v1/volumes?q=quilting")!)
        let bookList = try JSONDecoder().decode(BookListItems.self, from: data)
        return bookList.items
    }
  )

  /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
  /// to prove do not need the dependency.
  static let testValue = Self(
    fetch: unimplemented("\(Self.self).fetch")
  )
}
