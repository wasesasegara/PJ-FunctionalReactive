//
//  MainVC.swift
//  PJ FunctionalReactive
//
//  Created by Bisma S Wasesasegara on 5/13/19.
//  Copyright © 2019 Bisma S Wasesasegara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var name: BehaviorRelay<String> = BehaviorRelay(value: "Bisma")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainVC created.")
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("MainVC destroyed.")
    }
    
    func setupUI() {
        view.backgroundColor = wColor
        if let mainView = Bundle.main.loadNibNamed("Main", owner: self, options: nil)?.first as? MainView {
            view.addSubview(mainView)
            mainView.frame = view.frame
            name.asObservable()
                .bind(to: mainView.nameLabel.rx.text)
                .disposed(by: disposeBag)
            addActionButtons(mainView.changeNameButton)
        }
    }
    
    func addActionButtons(_ button: UIButton) {
        button.addTarget(self, action: #selector(showAlertController), for: .touchUpInside)
    }
    
    @objc func showAlertController() {
        let title = "Update Name"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let textInput = alert.textFields?.first?.text {
                self.name.accept(textInput)
            }
        }
        alert.addTextField()
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
