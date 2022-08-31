//
//  ViewController.swift
//  StackPinLayout
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import PinLayout
import Charts

class ViewController: UIViewController{
    
    let currentValuesData:[ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 1000, data: true),
        ChartDataEntry(x: 1.0, y: 2000, data: true),
        ChartDataEntry(x: 2.0, y: 3000, data: true),
        ChartDataEntry(x: 3.0, y: 4000, data: true),
        ChartDataEntry(x: 4.0, y: 5000, data: true),
        ChartDataEntry(x: 5.0, y: 6000, data: true),
        ChartDataEntry(x: 6.0, y: 7000, data: true),
    ]
    
    let targetValuesData:[ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10000.0, data: false),
        ChartDataEntry(x: 1.0, y: 20000.0, data: false),
        ChartDataEntry(x: 2.0, y: 30000.0, data: false),
        ChartDataEntry(x: 3.0, y: 40000.0, data: false),
        ChartDataEntry(x: 4.0, y: 50000.0, data: false),
        ChartDataEntry(x: 5.0, y: 60000.0, data: false),
        ChartDataEntry(x: 6.0, y: 70000.0, data: false),
        ChartDataEntry(x: 7.0, y: 80000.0, data: false),
        ChartDataEntry(x: 8.0, y: 90000.0, data: false),
        ChartDataEntry(x: 9.0, y: 100000.0, data: false),
        ChartDataEntry(x: 10.0, y: 110000.0, data: false),
        ChartDataEntry(x: 11.0, y: 120000.0, data: false),
    ]
    
    let monthFormat = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov", "Dec"]
    
    let parentView = ViewControllerView()
    
    override func viewDidLoad() {
        view = parentView
        view.backgroundColor = .white
        setData()
    }
}

extension ViewController:ChartViewDelegate{
    
    func setData(){
        let purpleSet = purpleSet()
        let graySet = graySet()
        
        let data = LineChartData(dataSets: [graySet, purpleSet])
        
        let lineChartView = parentView.lineChartView
        
        lineChartView.rightAxis.enabled = false
        
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 14, weight: .semibold)
        lineChartView.leftAxis.labelTextColor = .textTertiary
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = true
        lineChartView.leftAxis.gridColor = .neutral400
        lineChartView.leftAxis.valueFormatter = NumberAxisValueFormatter()
        lineChartView.leftAxis.xOffset = 16
        
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 14, weight: .semibold)
        lineChartView.xAxis.labelTextColor = .textTertiary
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.yOffset = 8
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthFormat)
        lineChartView.xAxis.axisLineColor = .textTertiary
        lineChartView.xAxis.axisLineWidth = 2
        lineChartView.xAxis.axisLineDashPhase = 4
        lineChartView.legend.enabled = false
        lineChartView.delegate = self
        lineChartView.xAxis.granularity = 1
        
        lineChartView.setDragOffsetX(20)
        lineChartView.zoom(scaleX: 2, scaleY: 1, x: 0, y: 1)
        lineChartView.moveViewToX(-1)
        
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        let marker = BalloonMarker()
        lineChartView.marker = marker
        
        lineChartView.layer.masksToBounds = false
        marker.layer.masksToBounds = false
        marker.clipsToBounds = false
        lineChartView.clipsToBounds = false
        
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    func purpleSet()->LineChartDataSet{
        let set1 = LineChartDataSet(entries: currentValuesData, label: "")
        
        set1.setColor(.violet600)
        set1.lineWidth = 3
        set1.setCircleColor(.white)
        set1.circleHoleColor = .violet600
        set1.circleHoleRadius = 3
        set1.circleRadius = 5
        return set1
    }
    
    func graySet()->LineChartDataSet{
        let set1 = LineChartDataSet(entries: targetValuesData, label: "")
        
        set1.setColor(.neutral500)
        set1.lineWidth = 3
        set1.setCircleColor(.white)
        set1.circleHoleColor = .neutral500
        set1.circleHoleRadius = 3
        set1.circleRadius = 5
        set1.lineDashLengths = [4]
        return set1
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let marker = chartView.marker as? BalloonMarker, let isCurrentValue = entry.data as? Bool{
            
            let date = ""
            let currentValue = isCurrentValue ? entry.y : currentValuesData[safe: Int(entry.x)]?.y
            let targetValue = !isCurrentValue ? entry.y : targetValuesData[safe: Int(entry.x)]?.y
            
            marker.setData(date: "\(monthFormat[Int(entry.x)]) '22", currentValue: currentValue?.simplify() ?? "-", targetValue: targetValue?.simplify() ?? "-", percentage: currentValue == nil ? "-" : "\(Int((currentValue! * 100)/targetValue!))%")
            
            handleOffset(marker: marker, chartView: chartView, entry: entry, highlight: highlight)
        }
    }
    
    func handleOffset(marker:BalloonMarker, chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        let pointRect = chartView.convert(CGRect(x: highlight.xPx, y: highlight.yPx, width: 0, height: 0), to: parentView)
        let chartRect = chartView.superview?.convert(chartView.frame, to: nil)
        let markerHeight = marker.frame.height
        let markerWidth = marker.frame.width
        
        if (pointRect.maxY + markerHeight) > chartRect?.maxY ?? 0{
            marker.offsetY()
        } else{
            marker.resetOffsetY()
        }
        
        if (pointRect.maxX + marker.frame.width) > chartRect?.maxX ?? 0{
            marker.offsetX()
        } else{
            marker.resetOffsetX()
        }
        
        if markerHeight == 0 || markerWidth == 0{
            parentView.lineChartView.delegate?.chartValueSelected?(chartView, entry: entry, highlight: highlight)
        }
    }
    
}

final class NumberAxisValueFormatter: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatNumber(Int(value)).replacingOccurrences(of: ".0", with: "")
    }
}

class ViewControllerView:UIView{
    
    let padding:CGFloat = 16
    
    let scrollView = UIScrollView()
    let container = UIView()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    let nameLabel = UILabel()
    let metricProgressStack = UIStackPinView()
    
    let statusLabel = UILabel()
    let statusContainer = UIView()
    
    let userProfileImage = UIImageView()
    let userDetailLabel = UILabel()
    
    let divider1 = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(frame: .zero)
        
        addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(nameLabel)
        container.addSubview(metricProgressStack)
        container.addSubview(statusContainer)
        container.addSubview(userProfileImage)
        container.addSubview(userDetailLabel)
        container.addSubview(divider1)
        statusContainer.addSubview(statusLabel)
        
        container.addSubview(lineChartView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performContent()
        performLayout()
    }
    
    func performContent(){
        nameLabel.text = "EBIDTA KFA (IDR 100,000)"
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .textPrimary
        
        metricProgressStack.removeArrangedSubviews()
        metricProgressStack.axis = .horizontal
        metricProgressStack.isManualWrap = true
        applyMetricProgress(view: metricProgressStack)
        
        statusLabel.text = "On Track"
        statusLabel.textColor = .green800
        statusLabel.setTheme(.caption)
        statusContainer.backgroundColor = .green200
        
        userProfileImage.backgroundColor = .textTertiary
        userProfileImage.layer.cornerRadius = 8
        userDetailLabel.text = "Nurtjahjo Walujo Wibowo · Direktur Utama KFA"
        userDetailLabel.setTheme(.caption)
        userDetailLabel.textColor = .textSecondary
        userDetailLabel.numberOfLines = 1
        
        statusContainer.layer.cornerRadius = 4
        divider1.backgroundColor = .neutral200
    }
    
    func performLayout(){
        scrollView.pin.all()
        
        container.pin.horizontally()
        
        nameLabel.pin.top(pin.safeArea + padding).horizontally(pin.safeArea + padding).sizeToFit(.width)
        
        metricProgressStack.pin.horizontally(pin.safeArea + padding).marginTop(16).wrapContent(.vertically).below(of: nameLabel)
        
        statusLabel.pin.sizeToFit()
        
        statusContainer.pin.wrapContent(.vertically, padding: 2).wrapContent(.horizontally, padding: 8).marginTop(8).left(pin.safeArea + padding).below(of: metricProgressStack)
        
        userProfileImage.pin.size(16).below(of: statusContainer).left(pin.safeArea + padding).marginTop(16)
        userDetailLabel.pin.vCenter(to: userProfileImage.edge.vCenter).right(of: userProfileImage).right(pin.safeArea + padding).sizeToFit(.width).marginLeft(4)
        
        divider1.pin.below(of: userProfileImage).horizontally().height(8).marginTop(16)
        
        lineChartView.pin.horizontally(pin.safeArea + padding).below(of: divider1).height(300).marginTop(16)
        
        container.pin.top(pin.safeArea).horizontally().wrapContent(.vertically)
        
        didPerformLayout()
    }
    
    func didPerformLayout() {
        scrollView.contentSize = CGSize(width: bounds.width, height: container.frame.maxY + 16)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
    }
    
}

extension ViewControllerView{
    func applyMetricProgress(view:UIStackPinView){
        view.addArrangedSubview(UILabel().apply{
            $0.text = "Rp "
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .textTertiary
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = "50 K"
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .green600
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = " / "
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .textTertiary
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = "100 K"
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .textPrimary
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = "("
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .green600
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UIImageView().apply{
            $0.image = UIImage(named: "arrow_drop_up")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .green600
            $0.pin.size(16).vCenter()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = "20%"
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .green600
            $0.pin.sizeToFit()
        })
        view.addArrangedSubview(UILabel().apply{
            $0.text = ")"
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .green600
            $0.pin.sizeToFit()
        })
    }
}

class CloneSuccessDialog:UIView{
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
    }
    
    
    func show(window:UIView){
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        performContent()
        performLayout()
        
    }
    
    func performContent(){
        
    }
    
    func performLayout() {
        
    }
    
}


struct SnackBar {
    static func show(message:String, keyboardHeight: CGFloat? = CGFloat(0)){
        SnackBarView().show(message: message, keyboardHeight: keyboardHeight)
    }
    
    class SnackBarView:UILabel{
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let messageLabel:UILabel={
            let label = UILabel()
            label.textColor = .white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = .systemFont(ofSize: 16)
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            addSubview(messageLabel)
        }
        
        func show(message:String, keyboardHeight:CGFloat? = CGFloat(0)) {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.addSubview(self)
            
            messageLabel.text = message
            
            pin.left().right().marginHorizontal(30)
            messageLabel.pin.all().width(of: self).sizeToFit(.width).margin(16)
            pin.left().right().marginHorizontal(16)
            if #available(iOS 11.0, *) {
                pin.wrapContent(padding: 14).bottom().marginBottom(window.safeAreaInsets.bottom + keyboardHeight!)
            }
            
            layer.cornerRadius = 8
            layer.masksToBounds = true
            backgroundColor = .gray
            
            self.transform = CGAffineTransform(translationX: 0, y: 100)
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(translationX: 0, y: -8)
            } completion: { Bool in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(translationX: 0, y: 8)
                } completion: { Bool in
                    UIView.animate(withDuration: 0.1) {
                        self.transform = CGAffineTransform(translationX: 0, y: 0)
                    } completion: { Bool in
                        // Wait for 2 Seconds
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { Timer in
                            // Hide Snackbar
                            UIView.animate(withDuration: 0.2) {
                                self.transform = CGAffineTransform(translationX: 0, y: 100)
                            } completion: { Bool in
                                // Remove SnackBar
                                self.removeFromSuperview()
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    
}
