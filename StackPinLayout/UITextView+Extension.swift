//
//  UITextView+Extension.swift
//  Performance
//
//  Created by Aditya Farhan on 12/08/21.
//

import Foundation
import UIKit

extension UITextView{
    
    enum ShouldChangeCursor {
        case incrementCursor
        case preserveCursor
    }

    func preserveCursorPosition(offset:Int? = nil, withChanges mutatingFunction: (UITextPosition?) -> (ShouldChangeCursor)) {
        //save the cursor positon
        var cursorPosition: UITextPosition? = nil
        if let selectedRange = self.selectedTextRange {
            let offset = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            cursorPosition = self.position(from: self.beginningOfDocument, offset: offset)
        }

        //make mutaing changes that may reset the cursor position
        let shouldChangeCursor = mutatingFunction(cursorPosition)

        //restore the cursor
        if var cursorPosition = cursorPosition {

            if shouldChangeCursor == .incrementCursor {
                cursorPosition = self.position(from: cursorPosition, offset: offset ?? 1) ?? cursorPosition
            }

            if let range = self.textRange(from: cursorPosition, to: cursorPosition) {
                self.selectedTextRange = range
            }
        }

    }
    
    func cursorPosition() -> Int {
        if let selectedRange = selectedTextRange {
            return offset(from: beginningOfDocument, to: selectedRange.start)
        }
        return 0
    }
}
