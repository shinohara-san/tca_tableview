//
//  Book.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

struct BookListItems: Decodable, Equatable {
    let items: [Book]
}

struct Book: Decodable, Equatable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable, Equatable {
    let title: String
}
