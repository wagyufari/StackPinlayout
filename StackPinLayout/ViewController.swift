//
//  ViewController.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import PinLayout

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        view = ViewControllerView()
        view.backgroundColor = .white
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
        scroll.pin.all()
        for i in 0...5 {
            stack.addArrangedSubview(UIView().apply{
                $0.pin.height(200)
                $0.pin.width(200)
                $0.backgroundColor = .blue
            })
            stack.addArrangedSubview(UIView().apply{
                $0.pin.height(200)
                $0.pin.width(200)
                $0.backgroundColor = .green
            })
        }
    }
    
    func didPerformLayout() {
        scroll.contentSize = CGSize(width: scroll.bounds.width, height: stack.frame.maxY)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
    }
}

class UIStackPinView: UIView{
    
    var subViews:[View] = []
    
    func addArrangedSubview(_ view:View)  {
        subViews.append(view)
        setNeedsLayout()
        layoutIfNeeded()
        pin.all().height(subviews.map{$0.frame.height}.reduce(0, +))
    }
    
    override func layoutSubviews() {
        subViews.forEach { UIView in
            addSubview(UIView)
        }
        if subViews.count > 1 {
            for (index, view) in subViews.enumerated() {
                if index != 0 {
                    view.pin.below(of: subViews[index-1])
                }
            }
        }
    }
}
