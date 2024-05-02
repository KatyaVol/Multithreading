//
//  MainViewBuilder.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import UIKit

final class MainViewBuilder {
    static func build() -> UIViewController {
        
        let requestService = RequestService()
        let networkService = NetworkService()
        let appService = AppService(networkService: networkService, requestService: requestService)
        let presenter = MainViewPresenter(appService: appService)
        let viewController = MainViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
