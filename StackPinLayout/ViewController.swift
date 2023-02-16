//
//  ViewController.swift
//  StackPinLayout
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import PinLayout
import RichEditorView
import WebKit


class ViewController: UIViewController, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "EditorMessage" {
            if let messageBody = message.body as? String {

                print("Received message from JavaScript: \(messageBody)")
            }
        }
    }
    
    
    var parentView: ViewControllerView?
    let userController = WKUserContentController()
    
    override func viewDidLoad() {
        let config = WKWebViewConfiguration()
        config.userContentController = userController
        parentView = ViewControllerView(configuration: config)
        guard let parentView = parentView else { return }
        view = parentView
        
        userController.add(self, name: "EditorMessage")
        
        let url = URL(string: "http://192.168.18.6:8000/")!

        parentView.webView.load(URLRequest(url: url))
        parentView.webView.allowsBackForwardNavigationGestures = false
        parentView.button.onTap { UITapGestureRecognizer in
            
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
    }
    
}

extension String {
    var htmlDecoded: String {
            guard let data = self.data(using: .utf8) else {
                return self
            }
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            do {
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                return attributedString.string
            } catch {
                return self
            }
        }
}

class ViewControllerView:UIView{
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let webView: WKWebView
    let button = UIView()
    
    init(configuration: WKWebViewConfiguration) {
        webView = WKWebView(frame: .zero, configuration: configuration)
        super.init(frame: .zero)
        addSubview(webView)
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
        button.backgroundColor = .violet600
        button.layer.cornerRadius = 64/2
    }
    
    func performLayout() {
        webView.pin.all()
        button.pin.top(pin.safeArea).marginRight(16).height(64).width(64).right()
    }
    
}

extension StringProtocol {
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
