//
//  LandingPageView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class LandingPageView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferEnterDataView = "TransferEnterDataVC"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageModalBottomView = "LandingPageModalBottomVC"

    }
    @IBOutlet weak var myExchangeTextField: UITextField!
        
        @IBOutlet weak var recipientTextField: UITextField!
        
        @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var currencyExchangeLabel: UILabel!
    
        var point : Point?
        var currencyList : [Currency]?
    //    var currency : String
        var currencyExchangeValue : Double = 15780.59
        
        override func viewDidLoad() {
            super.viewDidLoad()
            print("LandingPageView")
            myExchangeTextField.delegate = self
            recipientTextField.delegate = self
            
            setPoint { [weak self] data, error in
                guard let self = self else {
                    return
                }
                guard let data = data, error == nil else{
                    return
                }
                self.point = data
                DispatchQueue.main.async {
                    self.pointLabel.text = "\(data.pointBalance)"
                }
            }
            setCurrencyList { [weak self] data, error in
                guard let self = self else {
                    return
                }
                guard let data = data, error == nil else {
                    return
                }
                self.currencyList = data.currency
            }
            currencyExchangeLabel.text = "\(currencyExchangeValue)"
            
            recipientTextField.addTarget(self, action: #selector(didRecipientTextFieldChanged(textField:)), for: UIControl.Event.editingChanged)
            myExchangeTextField.addTarget(self, action: #selector(didMyExchangeTextFieldChanged(textField:)), for: UIControl.Event.editingChanged)
            
    //        setUpUI()
        }
        
        @objc func didMyExchangeTextFieldChanged(textField:UITextField){
            let textFieldContent = textField.text
            guard let textFieldContent = textFieldContent else {
                return
            }
            let value = Double(textFieldContent)
            guard let value = value else {
                return
            }
            print(currencyExchangeValue)
            recipientTextField.text = calculateChangesToRecipientChanges(value: value)
        }
        
        @objc func didRecipientTextFieldChanged(textField:UITextField){
            let textFieldContent = textField.text
            guard let textFieldContent = textFieldContent else {
                return
            }
            let value = Double(textFieldContent)
            guard let value = value else {
                return
            }
            print(currencyExchangeValue)
            myExchangeTextField.text = calculateChangesToMyExchange(value: value)
        }
        
        func calculateChangesToMyExchange(value : Double) -> String{
            return "\(value * currencyExchangeValue)"
        }
        
        func calculateChangesToRecipientChanges(value : Double) -> String{
            return "\(value / currencyExchangeValue)"
        }
        
        
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageModalBottomView) as? LandingPageModalBottomView else {
            fatalError("Failed to load landingPageModalBottomView from LandingPageView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}


extension LandingPageView : UITextFieldDelegate {
    
}


// MARK: - Setting up the UI
extension LandingPageView {
//    func setUpUI(){
//        setPoint()
//    }
}


extension LandingPageView {
    func setPoint(completion: @escaping (Point?, Error?) -> Void){
        fetchPoint { response, error in
            guard let response = response, error == nil else {
                print(error?.localizedDescription)
                completion(nil, error)
                return
            }
            completion(response,nil)
        }
    }
    func setCurrencyList(completion : @escaping (CurrencyList?, Error?) -> Void){
        fetchCurrency { response, error in
            guard let response = response, error == nil else {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }
}

// MARK: - API CALL
extension LandingPageView{
    func fetchPoint(handler : @escaping (Point?, Error?) -> Void){
        let url = URL(string: "https://paymentservice-mavipoc-payment-service.apps.mavipoc-pb.duh8.p1.openshiftapps.com/api/v1/point/CIF-00000")
        guard let url = url else{
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                handler(nil, error)
                return
              }
            guard let data = data, error == nil else {
                print("failed to connect")
                return
            }
            do {
                let jsonDecode = try JSONDecoder().decode(Point.self, from: data)
                handler(jsonDecode, nil)
            } catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchCurrency(handler : @escaping (CurrencyList?, Error?)->Void){
        let url = URL(string: "https://paymentservice-mavipoc-payment-service.apps.mavipoc-pb.duh8.p1.openshiftapps.com/api/v1/point/CIF-00000")
        guard let url = url else{
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                handler(nil, error)
                return
              }
            guard let data = data, error == nil else {
                print("failed to connect")
                return
            }
            do {
                let jsonDecode = try JSONDecoder().decode(CurrencyList.self, from: data)
                handler(jsonDecode, nil)
            } catch{
                print(error)
            }
        }
        task.resume()
    }
}
