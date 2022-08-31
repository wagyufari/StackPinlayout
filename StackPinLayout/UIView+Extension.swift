import Foundation
import UIKit

extension UIView {
    
    func onTap(_ handler: @escaping (UITapGestureRecognizer) -> Void) {
        onTapWithTapCount(1, run: handler)
    }
    
    func onDoubleTap(_ handler: @escaping (UITapGestureRecognizer) -> Void) {
        onTapWithTapCount(2, run: handler)
    }
    
    func onLongPress(_ handler: @escaping (UILongPressGestureRecognizer) -> Void) {
        addGestureRecognizer(UILongPressGestureRecognizer { gesture in
            handler(gesture as! UILongPressGestureRecognizer)
            })
    }
    
    func onSwipeLeft(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.left, run: handler)
    }
    
    func onSwipeRight(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.right, run: handler)
    }
    
    func onSwipeUp(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.up, run: handler)
    }
    
    func onSwipeDown(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.down, run: handler)
    }
    
    func onPan(_ handler: @escaping (UIPanGestureRecognizer) -> Void) {
        addGestureRecognizer(UIPanGestureRecognizer { gesture in
            handler(gesture as! UIPanGestureRecognizer)
            })
    }
    
    func onPinch(_ handler: @escaping (UIPinchGestureRecognizer) -> Void) {
        addGestureRecognizer(UIPinchGestureRecognizer { gesture in
            handler(gesture as! UIPinchGestureRecognizer)
            })
    }
    
    func onRotate(_ handler: @escaping (UIRotationGestureRecognizer) -> Void) {
        addGestureRecognizer(UIRotationGestureRecognizer { gesture in
            handler(gesture as! UIRotationGestureRecognizer)
            })
    }
}


private extension UIView {
    
    func onTapWithTapCount(_ numberOfTaps: Int, run handler: @escaping (UITapGestureRecognizer) -> Void) {
        let tapGesture = UITapGestureRecognizer { gesture in
            handler(gesture as! UITapGestureRecognizer)
        }
        tapGesture.numberOfTapsRequired = numberOfTaps
        addGestureRecognizer(tapGesture)
    }
    
    func onSwipeWithDirection(_ direction: UISwipeGestureRecognizer.Direction, run handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        let swipeGesture = UISwipeGestureRecognizer { gesture in
            handler(gesture as! UISwipeGestureRecognizer)
        }
        swipeGesture.direction = direction
        addGestureRecognizer(swipeGesture)
    }
}

extension UIGestureRecognizer {
    fileprivate var handler: GestureRecognizerClosureHandler! {
        get { return objc_getAssociatedObject(self, "one_gestureHandler") as? GestureRecognizerClosureHandler }
        set { objc_setAssociatedObject(self, "one_gestureHandler", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    convenience init(handler: @escaping (UIGestureRecognizer) -> Void) {
        let handler = GestureRecognizerClosureHandler(handler: handler)
        self.init(target: handler, action: #selector(GestureRecognizerClosureHandler.handleGesture(_:)))
        self.handler = handler
    }
}

class GestureRecognizerClosureHandler: NSObject {
    fileprivate let handler: (UIGestureRecognizer) -> Void
    init(handler: @escaping (UIGestureRecognizer) -> Void) { self.handler = handler }
    @objc func handleGesture(_ gestureRecognizer: UIGestureRecognizer) { handler(gestureRecognizer) }
}

extension UILabel {
    class func heightForView(text: String, font: UIFont, width: CGFloat, maxLines: Int) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = maxLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()		
        return label.frame.height
    }
    
    func setLineHeight(_ lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            style.alignment = .center
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    func setTheme(_ labelTheme: LabelTheme){
        switch labelTheme {
        case .title1:
            self.font = .systemFont(ofSize: 28, weight: .bold)
        case .title2:
            self.font = .systemFont(ofSize: 24, weight: .medium)
        case .title3:
            self.font = .systemFont(ofSize: 20, weight: .medium)
        case .title4:
            self.font = .systemFont(ofSize: 16, weight: .medium)
        case .title5:
            self.font = .systemFont(ofSize: 14, weight: .medium)
        case .title6:
            self.font = .systemFont(ofSize: 12, weight: .medium)
        case .body:
            self.font = .systemFont(ofSize: 16, weight: .regular)
        case .body2:
            self.font = .systemFont(ofSize: 14, weight: .regular)
        case .caption:
            self.font = .systemFont(ofSize: 12, weight: .regular)
        }
    }
}

enum LabelTheme{
    case title1
    case title2
    case title3
    case title4
    case title5
    case title6
    case body
    case body2
    case caption
}


