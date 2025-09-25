//
//  BaseController.swift
//  ClinicaSanAgustin
//
//  Created by Miguel Mexicano Herrera on 25/09/25.
//
import UIKit
class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
