//
//  Coordinator.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 04/03/23.
//

import UIKit

protocol CoordinatorViewController: UIViewController {
    var coordinator: Coordinator? { get set }
}

class Coordinator {
    var root: UINavigationController
    var childCoordinators = [Coordinator]()
    var whenCompleted: (() -> Void)?

    weak var firstVC: CoordinatorViewController?

    init(root: UINavigationController) {
        self.root = root
    }

    func startInStack(at index: Int) {
        let viewController = setFirstViewController()
        firstVC = viewController

        root.viewControllers.insert(viewController, at: index)
    }

    func setFirstViewController() -> CoordinatorViewController {
        fatalError("Must be overridden in subclass")
    }

    func goBack() {
        root.popViewController(animated: true)
    }

    func stop(animated: Bool = true) {
        for viewController in root.viewControllers where viewController == firstVC {
            root.popToViewController(viewController, animated: false)
            root.popViewController(animated: animated)
        }
    }
    
    func removeFromStack() {
        firstVC?.removeFromParent()
    }
    
    func pop<T>(toScreenOfType: T.Type) where T: UIViewController {
        if let foundVC = containsViewController(ofType: T.self) {
            root.popToViewController(foundVC, animated: true)
        }
    }

    func containsViewController<T>(ofType: T.Type) -> T? where T: UIViewController {
        return root.viewControllers.first { viewController -> Bool in
            viewController is T
        } as? T
    }

    deinit {
        logToConsole(message: "\(String(describing: self)) has been deinit")
    }
}
