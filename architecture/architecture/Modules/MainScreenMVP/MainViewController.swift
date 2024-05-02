//
//  MainViewController.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func fetchJokeSucceeded(joke: Joke)
    func fetchPostsSucceeded(posts: [Posts])
    func fetchImageSucceeded(image: Data)
    func fetchFailed(error: NetworkError)
    func stopActivityIndicator()
}

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let presenter: MainViewPresenterProtocol
    private var posts = [Posts]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Загрузить", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private let jokeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No joke"
        label.textAlignment = .center
        label.backgroundColor = .systemCyan
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private let myImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray2
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    // MARK: - Init
    
    init(presenter: MainViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .white
    }
    
    // MARK: - Action
    
    @objc private func buttonAction() {
        activityIndicator.startAnimating()
        presenter.fetchButtonTapped()
    }
    
    // MARK: - Methods
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func layout() {
        view.addSubview(fetchButton)
        view.addSubview(jokeLabel)
        view.addSubview(myImage)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            fetchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            fetchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fetchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fetchButton.heightAnchor.constraint(equalToConstant: 50),
            
            jokeLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            jokeLabel.leadingAnchor.constraint(equalTo: fetchButton.leadingAnchor),
            jokeLabel.trailingAnchor.constraint(equalTo: fetchButton.trailingAnchor),
            
            myImage.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 20),
            myImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myImage.heightAnchor.constraint(equalToConstant: 100),
            myImage.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: myImage.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: fetchButton.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: fetchButton.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = posts[indexPath.row].name
        content.secondaryText = posts[indexPath.row].email
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
    func fetchJokeSucceeded(joke: Joke) {
        self.jokeLabel.text = joke.value
    }
    
    func fetchPostsSucceeded(posts: [Posts]) {
        self.posts = posts
        self.tableView.reloadData()
    }
    
    func fetchImageSucceeded(image: Data) {
        self.myImage.image = UIImage(data: image)
    }
    
    func fetchFailed(error: NetworkError) {
        var errorMessage: String?
        
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        present(alertController,
                animated: true,
                completion: nil)
        
        switch error {
        case .badRequest:
            errorMessage = "Bad request. Please check your input."
        case .notFound:
            errorMessage = "Server error. Please try again later."
        case .serverError:
            errorMessage = "Server error. Please try again later."
        case .decodeError:
            errorMessage = "Server error. Please try again later."
        case .unknown:
            errorMessage = "unknown error. Please try again later."
        case .unAuthorized:
            errorMessage = "400 error. Please try again later."
        }
    }
}
