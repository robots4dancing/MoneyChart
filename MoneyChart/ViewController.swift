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
    var currencyBase    :String?
    var currencyLabels = [String]()
    var currencyValues = [Double]()
    
    //MARK: - Interactivty Methods
    
    @IBAction func barGraphPressed(button: UIButton) {
        //performSegue(withIdentifier: "barChartSegue", sender: button)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barChartSegue" {
            let destVC = segue.destination as! BarChartViewController
            destVC.currencyBase = currencyBase
            destVC.currencyLabels = currencyLabels
            destVC.currencyValues = currencyValues
        }
    }
    
    //MARK: - Data Retrieval Methods
    
    func parseJson(data: Data) {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            print("JSON:\(jsonResult)")
            currencyBase = jsonResult["base"] as? String
            let currencyDictionary = jsonResult["rates"] as! [String:Double]
            for (key, value) in currencyDictionary {
                print("Currency:\(key):\(value)")
                currencyLabels.append(key)
                currencyValues.append(value)
            }
                DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        getFile(filename: "latest?base=USD")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

