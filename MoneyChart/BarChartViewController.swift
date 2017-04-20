//
//  BarChartViewController.swift
//  MoneyChart
//
//  Created by Valerie Greer on 4/19/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController, IAxisValueFormatter {
    
    var currencyLabels = [String]()
    var currencyValues = [Double]()
    var currencyDictionary = [Double:String]()

    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let currency = currencyDictionary[value] {
            return currency
        } else {
            return ""
        }
    }
    
    @IBOutlet weak var barChartView :BarChartView!
    
    func setChart(labels: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.xAxis.labelRotationAngle = 270.0
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.axisMinimum = 0
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<labels.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            currencyDictionary[Double(i)] = currencyLabels[i]
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Currencies")
        chartDataSet.colors = ChartColorTemplates.joyful()
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(labels: currencyLabels, values: currencyValues)
        barChartView.xAxis.valueFormatter = self
        print(currencyLabels.count)
        print(currencyValues.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
