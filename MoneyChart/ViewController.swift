//
//  ViewController.swift
//  MoneyChart
//
//  Created by Valerie Greer on 4/18/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    let hostName = "api.fixer.io"
    let dateFormatter = DateFormatter()
    var currencyBase    :String?
    var currencyDate    :String?
    var currencyLabels = [String]()
    var currencyValues = [Double]()
    var fileName        :String?
    
    @IBOutlet var currencyDatePicker    :UIDatePicker?
    @IBOutlet var usdButton             :UIButton?
    @IBOutlet var eurButton             :UIButton?
    
    //MARK: - Interactivty Methods
    
    @IBAction func usdPressed(button: UIButton) {
        buttonSelectedOutline(button: button, otherButton: eurButton!)
        currencyBase = "USD"
    }
    
    @IBAction func eurPressed(button: UIButton) {
        buttonSelectedOutline(button: button, otherButton: usdButton!)
        currencyBase = "EUR"
    }
    
    func buttonSelectedOutline(button: UIButton, otherButton: UIButton) {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 1.0).cgColor
            otherButton.layer.borderWidth = 0
            otherButton.layer.borderColor = UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 0).cgColor
    }
    
    @IBAction func barGraphPressed(button: UIButton) {
        currencyLabels.removeAll()
        currencyValues.removeAll()
        currencyDate = dateFormatter.string(from: (currencyDatePicker?.date)!)
        fileName = "\(String(describing: currencyDate!))?base=\(String(describing: currencyBase!))"
        print(fileName!)
        getFile(filename: fileName!)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barChartSegue" {
                let destVC = segue.destination as! BarChartViewController
                destVC.currencyBase = currencyBase
                destVC.currencyDate = currencyDate
                destVC.currencyLabels = currencyLabels
                destVC.currencyValues = currencyValues
        }
    }
    
    //MARK: - Setup Methods
    
    func setupDatePicker() {
        currencyDatePicker?.datePickerMode = UIDatePickerMode.date
        currencyDatePicker?.maximumDate = Date()
        currencyDatePicker?.minimumDate = dateFormatter.date(from: "1999-01-01")
    }
    
    //MARK: - Data Retrieval Methods
    
    func parseJson(data: Data) {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            //print("JSON:\(jsonResult)")
            let currencyDictionary = jsonResult["rates"] as! [String:Double]
            for (key, value) in currencyDictionary {
                //print("Currency:\(key):\(value)")
                if key != "IDR" && key != "KRW" {
                currencyLabels.append(key)
                currencyValues.append(value)
                } else {
                    continue
                }
            }
                DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.performSegue(withIdentifier: "barChartSegue", sender: nil)
            }
        } catch {
            print("JSON Parsing Error")
        }
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func getFile(filename: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlString = "https://\(hostName)/\(filename)"
        print("\(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let recvData = data else {
                print("No Data")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if recvData.count > 0 && error == nil {
                print("Got Data:\(recvData)")
                let dataString = String.init(data: recvData, encoding: .utf8)
                print("Got Data String:\(String(describing: dataString))")
                self.parseJson(data: recvData)
            } else {
                print("Got Data of Length 0")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
    }

    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setupDatePicker()
        buttonSelectedOutline(button: usdButton!, otherButton: eurButton!)
        currencyBase = "USD"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

