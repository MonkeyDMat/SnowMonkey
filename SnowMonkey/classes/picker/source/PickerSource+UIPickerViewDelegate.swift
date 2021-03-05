//
//  PickerSource+UIPickerViewDelegate.swift
//  SnowMonkey
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

extension PickerSource: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return components[component].layout.width
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if component < components.count {
            return components[component].layout.height
        } else {
            return PickerComponentLayout.default.height
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[component].rows[row].text
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return components[component].rows[row].attributedText
    }
    
    /*public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return components[component].rows[row].view ?? UIView()
    }*/
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let picker = picker else {
            return
        }
        delegate?.didSelectRow(picker: picker, row: row, inComponent: component)
    }
}
