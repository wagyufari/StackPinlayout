//
//  FloatingCommentView.swift
//  Performance
//
//  Created by Muhammad Ghifari on 16/10/22.
//



import Foundation
import UIKit
import PinLayout
import Typist
import MarkdownView
import CocoaMarkdown
import RichEditorView
import WebKit

class FloatingTextFieldView: BottomSheetControllerView, UITextViewDelegate {
    
    lazy var textView: WKWebView = {
        let view = WKWebView()
//        view.textColor = .neutral400
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 8
//        view.textColor = .gray
//        view.theme = .body
//        view.delegate = self
        return view
    }()
    
    let toolbar = RichEditorToolbar(frame: .zero)
    
    let downExpandIcon = UIImageView()
    let downContainer = UIView()
    let downView = MarkdownView()
    
    let keyboard = Typist.shared
    var keyboardHeight:CGFloat = 0
    var isDownExpanded = false
    
    let previewPlaceholder = NSMutableAttributedString(string: "Preview will show here", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8), NSAttributedString.Key.foregroundColor : UIColor.textTertiary])
    
    override init() {
        super.init()
        
        isFullScreen = true
        
        addSubview(toolbar)
        
        container.addSubview(textView)
        container.addSubview(downContainer)
        
        downContainer.addSubview(downView)
        downContainer.addSubview(downExpandIcon)
        
        keyboard.on(event: .willShow) { [weak self] (options) in
            self?.keyboardHeight = options.endFrame.size.height
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }
        .start()
        
        keyboard.on(event: .willHide) { [weak self] (options) in
            self?.keyboardHeight = self?.pin.safeArea.bottom ?? 0
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }
        .start()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performContent()
        performLayout()
    }
    
    func performContent() {
        downContainer.backgroundColor = .white
        
        downExpandIcon.image = UIImage(named: "open_in_full")?.withRenderingMode(.alwaysTemplate)
        downExpandIcon.tintColor = .neutral500
        downExpandIcon.onTap { UITapGestureRecognizer in
            self.isDownExpanded = !self.isDownExpanded
            self.isDownExpanded ? self.textView.resignFirstResponder() : self.textView.becomeFirstResponder()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    func performLayout(mdHeight: CGFloat? = 0) {
        
        downView.backgroundColor = .clear
        downView.layer.cornerRadius = 8
        
        downContainer.backgroundColor = .neutral300
        downContainer.layer.cornerRadius = 8
        
        if isDownExpanded {
            downContainer.pin.all()
        } else {
            downContainer.pin.horizontally(16).bottom(keyboardHeight + 16).height(128)
            
            textView.pin.top(16).horizontally(8).above(of: downContainer).marginBottom(12)
        }
        
        downView.pin.vertically(isDownExpanded ? 32 : 16).horizontally()
        downExpandIcon.pin.top(16).right(16).height(24).width(24)
        
        super.layoutSubviews()
        updateMarkdown()
        
        toolbar.pin.horizontally().height(44).bottom(keyboardHeight)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didEndEditing = false
    var rawText = ""
//    func textViewDidEndEditing(_ textView: UITextView) {
//        didEndEditing = true
//        textView.attributedText = NSMutableAttributedString(string: rawText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        didEndEditing = false
//        textView.attributedText = NSMutableAttributedString(string: rawText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateMarkdown()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    func updateMarkdown() {
        
        
//        let bold = matches(for: "(\\*\\*(?<bold>[^*]*)\\*\\*)", in: text)
//        let italic = matches(for: "(\\_(?<italic>[^*]*)\\_)", in: text)
//        let boldItalic = matches(for: "(\\*\\*\\_(?<boldAndItalic>[^*]*)\\_\\*\\*)|(\\_\\*\\*(?<boldAndItalic2>[^*]*)\\*\\*\\_)", in: text)
//        let h1 = matches(for: "(#{1}\\s)(.*)", in: text)
//        let h2 = matches(for: "(#{2}\\s)(.*)", in: text)
//        let h3 = matches(for: "(#{3}\\s)(.*)", in: text)
//        let h4 = matches(for: "(#{4}\\s)(.*)", in: text)
//        let h5 = matches(for: "(#{5}\\s)(.*)", in: text)
//        let h6 = matches(for: "(#{6}\\s)(.*)", in: text)
//        let codeblock = matches(for: "(\\`{1})(.*)(\\`{1})", in: text)
//        let listText = matches(for: "^\\s*\\xE2\\x80\\xA2\\s+(.+)", in: text)
//
//        textView.font = .systemFont(ofSize: 16)
//
//        var attrText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//
//        h1.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 2 ? 2 : 1))
//        }
//
//        h2.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 3 ? 3 : 2))
//        }
//
//        h3.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 4 ? 4 : 3))
//        }
//
//        h4.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 5 ? 5 : 4))
//        }
//
//        h5.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 6 ? 6 : 5))
//        }
//
//        h6.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: range.length > 7 ? 7 : 6))
//        }
//
//        bold.forEach { range in
//            let font = textView.attributedText.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as? UIFont ?? UIFont.systemFont(ofSize: 16)
//            attrText.addAttributes([NSAttributedString.Key.font: font.with([.traitBold])], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0) ], range: NSRange(location: range.location, length: 2))
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0) ], range: NSRange(location: range.location + range.length - 2, length: 2))
//
//        }
//
//        italic.forEach { range in
//            let font = textView.attributedText.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as? UIFont ?? UIFont.systemFont(ofSize: 16)
//            attrText.addAttributes([NSAttributedString.Key.font: font.with([.traitItalic])], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: 1))
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location + range.length - 1, length: 1))
//
//        }
//
//        boldItalic.forEach { range in
//            let font = textView.attributedText.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as? UIFont ?? UIFont.systemFont(ofSize: 16)
//            attrText.addAttributes([NSAttributedString.Key.font: font.with([.traitItalic, .traitBold])], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: 3))
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location + range.length - 3, length: 3))
//
//        }
//
//        codeblock.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.neutral300], range: range)
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: 1))
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location + range.length - 1, length: 1))
//        }
//
//        listText.forEach { range in
//            attrText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textTertiary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ], range: NSRange(location: range.location, length: 2))
//        }
//
//        textView.preserveCursorPosition { _ in
//                rawText = textView.text
//                textView.attributedText = attrText
//
//            return .preserveCursor
//        }
        
        let smallCss = [
            "h1 { font-size: 16px;  line-height: 0px;  margin-top: 7px; margin-bottom: 18px}",
            "h2 { font-size: 14px;  line-height: 0px;  margin-top: 7px; margin-bottom: 18px}",
            "h3 { font-size: 12px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px}",
            "h4 { font-size: 10px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px}",
            "h5 { font-size: 10px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px}",
            "h6 { font-size: 10px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px}",
            "p { font-size: 8px;}",
            "code { font-size: 8px;}",
            "ul { font-size: 8px;}",
        ].joined(separator: "\n")
        
        let css = [
            "h1 { font-size: 28px;  line-height: 0px;  margin-top: 14px; margin-bottom: 28px;}",
            "h2 { font-size: 24px;  line-height: 0px;  margin-top: 9px; margin-bottom: 22px;}",
            "h3 { font-size: 20px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px;}",
            "h4 { font-size: 16px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px;}",
            "h5 { font-size: 14px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px;}",
            "h6 { font-size: 12px;  line-height: 0px;  margin-top: 7px; margin-bottom: 14px;}",
            "p { font-size: 14px;}",
            "code { font-size: 14px;}",
            "ul { font-size: 14px;}",
            "ol { font-size: 14px;}",
        ].joined(separator: "\n")
        
        downView.load(markdown: rawText, enableImage: false, css: isDownExpanded ? css : smallCss)
    }
    
    
    
    
    func matches(for regex: String, in text: String) -> [NSRange] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

            return matches.map {
                $0.range
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}

extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }



    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
