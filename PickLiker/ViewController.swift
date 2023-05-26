//
//  ViewController.swift
//  PickLiker
//
//  Created by Vladimir on 26.05.2023.
//

import UIKit

class ViewController: UIViewController {
    var pictures = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let button = UIButton(type: .system)
        button.frame = CGRect(x: 130, y: 100, width: 100, height: 50)
        button.backgroundColor = .black
        button.setTitle("show images", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.titleColor(for: .disabled)
        self.view.addSubview(button)
    }

    @objc func buttonClicked(_ sender: UIButton) {
        navigationController?.pushViewController(ImageLoaderController(), animated: true)
//        print("Button tapped")
      }
}
