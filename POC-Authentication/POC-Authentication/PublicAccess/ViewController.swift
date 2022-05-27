//
//  ViewController.swift
//  POC-Authentication
//
//  Created by Robson Novato Lobao on 23/05/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    var error1: NSError? = nil
    var error2: NSError? = nil
    var userHasPin: Bool = false
    var userHasFaceId: Bool = false
    let context = LAContext()
    
    func pin() {
        let reason = "Digite o pin"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
            [weak self] success, error in
            DispatchQueue.main.async {
                guard success, error == nil else {
                    let alert = UIAlertController(title: "Autenticacao por pin falhou", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Sair", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                let vc = PrivateAccessViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    func faceID() {
        let reason = "Insira faceID"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [weak self] success, error in
            DispatchQueue.main.async {
                guard success, error == nil else {
                    return
                }
                let vc = PrivateAccessViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    func userDoesNotHaveAuth() {
        let alert = UIAlertController(title: "Usuário não possui Autenticação", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sair", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func privateButton(_ sender: Any) {
        if userHasFaceId {
            faceID()
        }
        if userHasPin && !userHasFaceId {
            pin()
        } else if !userHasPin && !userHasFaceId {
            userDoesNotHaveAuth()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
    }
    
    private func setupUser() {
        userHasPin = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error1) ? true : false
        userHasFaceId = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error2) ? true : false
    }
}

