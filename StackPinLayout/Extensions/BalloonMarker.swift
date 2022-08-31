//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts
import UIKit


class BalloonMarker: MarkerView
{
    
    let dateLabel = UILabel()
    let currentValueColor = UIView()
    let targetValueColor = UIView()
    
    let currentValueLabelTitle = UILabel()
    let targetValueLabelTitle = UILabel()
    let currentValueLabel = UILabel()
    let targetValueLabel = UILabel()
    
    let percentageLabelTitle = UILabel()
    let percentageLabel = UILabel()
    
    var padding:CGFloat = 12
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(frame: .zero)
        addSubview(dateLabel)
        addSubview(currentValueColor)
        addSubview(targetValueColor)
        addSubview(currentValueLabel)
        addSubview(targetValueLabel)
        addSubview(currentValueLabelTitle)
        addSubview(targetValueLabelTitle)
        addSubview(percentageLabelTitle)
        addSubview(percentageLabel)
    }
    
    func offsetY(){
        self.offset = CGPoint(x: self.offset.x, y: -self.frame.height)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func resetOffsetY(){
        self.offset = CGPoint(x: self.offset.x, y: 0)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func offsetX(){
        self.offset = CGPoint(x: -self.frame.width, y: self.offset.y)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func resetOffsetX(){
        self.offset = CGPoint(x: 0, y: self.offset.y)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setData(date:String, currentValue:String, targetValue:String, percentage:String){
        dateLabel.text = date
        currentValueLabel.text = currentValue
        targetValueLabel.text = targetValue
        percentageLabel.text = percentage
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.pin.width(180)
        
        
        dateLabel.font = .systemFont(ofSize: 12)
        currentValueColor.backgroundColor = .violet600
        currentValueColor.layer.cornerRadius = 4
        targetValueColor.backgroundColor = .textTertiary
        targetValueColor.layer.cornerRadius = 4
        
        currentValueLabelTitle.text = "Achievement"
        currentValueLabelTitle.font = .systemFont(ofSize: 12)
        targetValueLabelTitle.text = "Target"
        targetValueLabelTitle.font = .systemFont(ofSize: 12)
        
        
        currentValueLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        targetValueLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        percentageLabelTitle.text = "(%) Achievement"
        percentageLabelTitle.font = .systemFont(ofSize: 12)
        
        percentageLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        dateLabel.pin.sizeToFit().top().left(padding)
        
        currentValueColor.pin.size(8).below(of: dateLabel).marginTop(8).left(to: dateLabel.edge.left)
        currentValueLabelTitle.pin.vCenter(to: currentValueColor.edge.vCenter).sizeToFit().right(of: currentValueColor).marginLeft(4)
        currentValueLabel.pin.vCenter(to: currentValueColor.edge.vCenter).right(padding).sizeToFit()
        
        targetValueColor.pin.size(8).below(of: currentValueColor).marginTop(8).left(to: dateLabel.edge.left)
        targetValueLabelTitle.pin.vCenter(to: targetValueColor.edge.vCenter).sizeToFit().right(of: targetValueColor).marginLeft(4)
        targetValueLabel.pin.vCenter(to: targetValueColor.edge.vCenter).right(padding).sizeToFit()
        
        percentageLabelTitle.pin.below(of: targetValueColor).marginTop(16).left(to: dateLabel.edge.left).sizeToFit()
        percentageLabel.pin.vCenter(to: percentageLabelTitle.edge.vCenter).right(padding).sizeToFit()
        
        backgroundColor = .white
        pin.wrapContent(.vertically, padding: padding)
        layer.borderColor = UIColor.neutral400.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
    }
    
    
}
