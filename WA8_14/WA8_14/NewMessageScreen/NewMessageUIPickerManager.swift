//
//  NewMessageUIPickerManager.swift
//  WA8_14
//
//  Created by Diya on 11/21/23.
//

import Foundation
import UIKit

//picker view handling for list of users/contacts
extension NewMessageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedName = userNames[row]
        newMessageView.recipientTextField.text = selectedName
        didSelectName?(selectedName)
    }
    
}
