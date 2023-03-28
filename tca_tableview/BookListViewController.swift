//
//  BookListViewController.swift
//  tca_tableview
//
//  Created by shinohara.yuki.2250 on 2023/03/26.
//

import UIKit
import ComposableArchitecture
import Combine

class BookListViewController: UIViewController {
    private let viewStore: ViewStoreOf<BookList> = ViewStore(Store(initialState: BookList.State(), reducer: BookList())) // TODO: should be injected through init
    private var cancellables: Set<AnyCancellable> = []
    private var books: [Book] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Books - TCA"
        self.viewStore.send(.fetchBooks)
        
        self.viewStore.publisher
            .sink { [weak self] in
                self?.books = $0.books
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        self.viewStore.publisher
            .map(\.isShowingAlert)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showAlert()
            }
            .store(in: &cancellables)
        
        self.viewStore.publisher
            .map(\.isShowingIndicator)
            .sink { [weak self] isShowing in
                if isShowing {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewStore.send(.dismissAlert)
        })
        present(alert, animated: true)
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].volumeInfo.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "BookDetail", bundle: nil)
        let book = books[indexPath.row]
        let vc = storyboard.instantiateViewController(withIdentifier: "Detail") as! BookDetailViewController
        vc.instantiate(store: Store(initialState: BookDetail.State(book: book), reducer: BookDetail()))
        navigationController?.pushViewController(vc, animated: true)
    }
}
