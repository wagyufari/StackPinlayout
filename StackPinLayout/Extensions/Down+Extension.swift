//
//  Down+Extension.swift
//  Performance
//
//  Created by Muhammad Ghifari on 14/2/2023.
//

import Foundation
import Down

extension Down{
    static func getParagraphStyling(spacing: CGFloat) -> StaticParagraphStyleCollection {
        var style = StaticParagraphStyleCollection()
        let headingStyle = NSMutableParagraphStyle()
        headingStyle.paragraphSpacing = spacing

        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacingBefore = spacing
        bodyStyle.paragraphSpacing = spacing
        bodyStyle.lineSpacing = spacing

        let codeStyle = NSMutableParagraphStyle()
        codeStyle.paragraphSpacingBefore = spacing
        codeStyle.paragraphSpacing = spacing

        style.heading1 = headingStyle
        style.heading2 = headingStyle
        style.heading3 = headingStyle
        style.heading4 = headingStyle
        style.heading5 = headingStyle
        style.heading6 = headingStyle
        style.body = bodyStyle
        style.code = codeStyle
        return style
    }
}
