//
//  ViewController.swift
//  StackPinLayout
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import PinLayout

class ViewController: UIViewController{
    
    let parentView = ViewControllerView()
    
    override func viewDidLoad() {
        view = parentView
        view.backgroundColor = .white
        
        parentView.stack.isManualWrap = true
        for i in 0...5 {
            parentView.stack.addArrangedSubview(UIView().apply{
                $0.pin.height(200)
                $0.pin.width(200)
                $0.backgroundColor = .blue
            })
            parentView.stack.addArrangedSubview(UIView().apply{
                $0.pin.height(200)
                $0.pin.width(200)
                $0.backgroundColor = .green
            })
        }
        parentView.scroll.backgroundColor = .red
        
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
}

class ViewControllerView:UIView{
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stack:UIStackPinView={
        return UIStackPinView()
    }()
    
    var scroll:UIScrollView = {
       return UIScrollView()
    }()
    
    var isSetHeightWithMaxHeight = false
    
    init() {
        super.init(frame: .zero)
        addSubview(scroll)
        scroll.addSubview(stack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
        didPerformLayout()
    }
    
    func performLayout() {
        scroll.pin.top().horizontally()
        
        if isSetHeightWithMaxHeight {
            scroll.pin.height(320)
        }
        
        stack.axis = .vertical
        
        stack.pin.top().horizontally().wrapContent(.vertically)
        
        if !isSetHeightWithMaxHeight {
            scroll.pin.wrapContent(.vertically)
            if stack.frame.maxY > 320 {
                isSetHeightWithMaxHeight = true
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
    
    func didPerformLayout() {
        scroll.contentSize = CGSize(width: scroll.bounds.width, height: stack.frame.maxY)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
        
    }
}
