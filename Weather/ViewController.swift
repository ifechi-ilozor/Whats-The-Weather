//
//  ViewController.swift
//  Weather
//
//  Created by Ifechi Ilozor on 6/26/19.
//  Copyright © 2019 Ifechi Ilozor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func buttonTapped(_ sender: Any) {
        
        if let city = textField.text {
            var prevChar = ""
            var updateChar = ""
            var nsCity = city.replacingOccurrences(of: " ", with: "-")
            for character in nsCity {
                if prevChar == "" || prevChar == "-" {
                    updateChar = String(character).uppercased()
                    nsCity = nsCity.replacingOccurrences(of: String(character), with: updateChar)
                    prevChar = updateChar
                } else {
                    prevChar = String(character)
                }
            }
            nsCity = nsCity.replacingOccurrences(of: "St.", with: "Saint") //for special cases
            if let url = URL(string: "https://www.weather-forecast.com/locations/" + nsCity + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if error != nil {
                    message = "An error has occurred in our system. Please try again. Make sure to use correct spelling."
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "</h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    
                                }
                            }
                        }
                        
                    }
                }
                if message == "" {
                    message = "Weather couldn't be found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {self.resultLabel.text = message})
            }
            task.resume()
            } else {
                resultLabel.text = "Weather couldn't be found. Please try again. Make sure to enter valid city."
            }
            
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

