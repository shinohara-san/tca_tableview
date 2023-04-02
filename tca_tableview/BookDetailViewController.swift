//
//  BookDetailViewController.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import UIKit
import ComposableArchitecture
import Combine

class BookDetailViewController: UIViewController {
    var store: StoreOf<BookDetail>?
    var viewStore: ViewStoreOf<BookDetail>?
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet private weak var titleLabel: UILabel!

    func instantiate(store: StoreOf<BookDetail>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStore.publisher
            .map(\.book?.volumeInfo.title)
            .sink { [weak self] in
                guard let self else { return }
                self.titleLabel.text = $0
            }
            .store(in: &cancellables)
    }
}
