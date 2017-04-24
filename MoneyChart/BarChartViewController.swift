//
//  BarChartViewController.swift
//  MoneyChart
//
//  Created by Valerie Greer on 4/19/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController, IAxisValueFormatter, IValueFormatter{
    
    var currencyBase    :String?
    var currencyDate    :String?
    var currencyLabels = [String]()
    var currencyValues = [Double]()
    var currencyDictionary = [Double:String]()

    @IBOutlet weak var barChartView     :BarChartView!
    @IBOutlet weak var barChartTitle    :UINavigationItem!
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let currency = currencyDictionary[value] {
            return currency
        } else {
            return ""
        }
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value)
    }
    
    func setChart(labels: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.xAxis.labelRotationAngle = 270.0
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.axisMinimum = 0
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelCount = 31
        barChartView.xAxis.granularity = 1

        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<labels.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            currencyDictionary[Double(i)] = currencyLabels[i]
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.valueFormatter = self
        chartDataSet.colors = ChartColorTemplates.joyful()
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.setScaleMinima(2.9, scaleY: 8)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        barChartTitle.title = "Compared to \(currencyBase!) \(currencyDate!)"
        setChart(labels: currencyLabels, values: currencyValues)
        barChartView.xAxis.valueFormatter = self
        //print(currencyLabels.count)
        //print(currencyValues.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
