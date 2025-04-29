//
//  LineChartView.swift
//  ChatExample
//
//  Created by Justin Lai on 2025/4/28.
//  Copyright © 2025 MessageKit. All rights reserved.
//

import CorePlot
import UIKit

struct AxisScaleModel {
    let min: Float
    let interval: Float
}

class LineChartView: UIView {
    private let dateTransformer = H2SDateTransformer()
    // swiftlint:disable implicitly_unwrapped_optional
    private var hostView: CPTGraphHostingView!
    // swiftlint:enable implicitly_unwrapped_optional
    private var viewModel = MessageChartGraphData(
        graphType: .straightLine,
        yAxisProperties: MessageChartAxisProperties(
            label: "Weight",
            unit: "kg",
            dataType: .decimal,
            axisNumberFormat: .tenth,
            min: nil,
            max: nil,
            tickInterval: nil,
            showGridlines: true
        ),
        xAxisProperties: MessageChartAxisProperties(
            label: "Time",
            unit: "Date",
            dataType: .date,
            axisNumberFormat: nil,
            min: nil,
            max: nil,
            tickInterval: nil,
            showGridlines: false
        ),
        series: [
            MessageChartGraphSeries(
                metadata: MessageChartGraphSeriesMetadata(
                    name: "",
                    lineType: .solidWithDataPoints,
                    lineColor: "#286157",
                    showXValueLabel: false,
                    showYValueLabel: true
                ),
                data: [
                    MessageChartGraphSeriesDataPoint(xAxis: "2024-07-01", yAxis: "77.8", showLabel: true),
                    MessageChartGraphSeriesDataPoint(xAxis: "2024-12-08", yAxis: "77.3", showLabel: true),
                    MessageChartGraphSeriesDataPoint(xAxis: "2024-12-15", yAxis: "76.5", showLabel: true),
                    MessageChartGraphSeriesDataPoint(xAxis: "2024-12-22", yAxis: "75.8", showLabel: true),
                    MessageChartGraphSeriesDataPoint(xAxis: "2024-12-28", yAxis: "75.2", showLabel: true)
                ],
                icons: []
            )
        ]
    )
    private var ySpaceCount = 3
    private var isFirstLayout = true
    private lazy var hostViewWidth: CGFloat = {
        return hostView.bounds.size.width
    }()

    private var textStyle: CPTMutableTextStyle {
        CPTMutableTextStyle.dashBoardTextStyle()
    }

    private lazy var calendar: Calendar = {
       return Calendar(identifier: .gregorian)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initPlot()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPlot()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstLayout {
            isFirstLayout = false
            reloadCharts()
        }
    }

    func reloadCharts() {
        configureAxisLabels()
        hostView.hostedGraph?.reloadData()
    }

    // MARK: - Private

    private func initPlot() {
        configureHost()
        configureGraph()
        configureAxes()
        configureChart()
    }

    private func configureHost() {
        hostView = CPTGraphHostingView(frame: bounds)
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostView.allowPinchScaling = false
        hostView.backgroundColor = UIColor.clear
        addSubview(hostView)
    }

    private func configureGraph() {
        // 1 - Create the graph
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.fill = CPTFill(color: CPTColor.clear())
        graph.plotAreaFrame?.masksToBorder = false
        graph.plotAreaFrame?.paddingTop = 0
        graph.plotAreaFrame?.paddingBottom = 30
        graph.plotAreaFrame?.paddingLeft = 30
        graph.plotAreaFrame?.paddingRight = 0
        hostView.hostedGraph = graph
    }

    private func configureChart() {
        guard let hostGraph = hostView.hostedGraph else {
            return
        }

        // create chart
        let scatterChart = CPTScatterPlot(frame: hostView.frame)
        
        // 設置線的樣式
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 2
        lineStyle.lineColor = CPTColor(componentRed: 0.157, green: 0.380, blue: 0.341, alpha: 1.0) // #286157
        scatterChart.dataLineStyle = lineStyle
        
        // 設置點的樣式
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 1
        symbolLineStyle.lineColor = CPTColor(componentRed: 0.157, green: 0.380, blue: 0.341, alpha: 1.0)
        
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill = CPTFill(color: CPTColor.white())
        plotSymbol.lineStyle = symbolLineStyle
        plotSymbol.size = CGSize(width: 6, height: 6)
        scatterChart.plotSymbol = plotSymbol
        
        scatterChart.dataSource = self
        scatterChart.delegate = self
        
        hostGraph.add(scatterChart)
    }

    private func configureAxes() {
        // get axis set
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let graph = hostView.hostedGraph else {
            return
        }

        let axisLineStyle = CPTMutableLineStyle.makeLineStyle(lineWidth: 1, lineColor: CPTColor.gray300())
        let xAxisDashLineStyle = CPTMutableLineStyle()
        xAxisDashLineStyle.dashPattern = [NSDecimalNumber(value: 3)]
        xAxisDashLineStyle.lineColor = CPTColor.gray300()

        // configure x-axis
        if let xAxis = axisSet.xAxis {
            let axisXConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            xAxis.axisConstraints = axisXConstraints
            xAxis.majorGridLineStyle = xAxisDashLineStyle
            xAxis.axisLineStyle = axisLineStyle
            xAxis.labelingPolicy = .none
            
            // Add X-axis title
            xAxis.title = "Time"
            xAxis.titleOffset = 25.0  // Adjust this value to position the title
            xAxis.titleTextStyle = textStyle
        }

        // configure y-axis
        if let yAxis = axisSet.yAxis {
            let axisYConstraints = CPTConstraints.constraint(withLowerOffset: 0)
            yAxis.axisConstraints = axisYConstraints
            yAxis.axisLineStyle = nil
            yAxis.majorGridLineStyle = axisLineStyle
            yAxis.labelingPolicy = .none
            yAxis.majorTickLength = 0
            
            // Add Y-axis title
            yAxis.title = "Lab result detail"
            yAxis.titleOffset = 35.0  // Adjust this value to position the title
            yAxis.titleRotation = CGFloat.pi / 2  // Rotate title 90 degrees
            yAxis.titleTextStyle = textStyle
        }

        graph.axisSet?.axes = [axisSet.xAxis, axisSet.yAxis] as? [CPTAxis]
    }

    private func configureYAxisLabelModel() -> AxisScaleModel {
        guard let series = viewModel.series.first else {
            return AxisScaleModel(min: 0, interval: 1)
        }
        
        var finalDailyDataMin: Float = Float(series.data.first?.yAxis ?? "0") ?? 0
        var finalDailyDataMax: Float = Float(series.data.first?.yAxis ?? "0") ?? 0
        
        series.data.forEach { point in
            if let value = Float(point.yAxis) {
                finalDailyDataMin = min(finalDailyDataMin, value)
                finalDailyDataMax = max(finalDailyDataMax, value)
            }
        }
        
        let testMinValue = finalDailyDataMin
        let testMaxValue = finalDailyDataMax

        return fetchAxisRange(min: testMinValue, max: testMaxValue, axisCount: ySpaceCount)
    }

    private func configureAxisLabels() {
        guard let graph = hostView.hostedGraph, let space = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        space.allowsUserInteraction = true
        space.delegate = self

        // configure x-axis
        let xMin: CGFloat = 0
        let xMax = hostView.bounds.size.width
        let xPadding = xMax * 0.02 // 左右各留 1% 的空間
        space.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin - xPadding), lengthDecimal: CPTDecimalFromCGFloat(xMax + xPadding * 2))
        space.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromCGFloat(xMin - xPadding), lengthDecimal: CPTDecimalFromCGFloat(xMax + xPadding * 2))
        
        updateXAxisLabels(space: space)

        // configure y-axis
        let scatterYAxisModel = configureYAxisLabelModel()
        let scatterYMax = scatterYAxisModel.min + Float(ySpaceCount) * scatterYAxisModel.interval
        configureYAxisLabels(yMin: scatterYAxisModel.min, yMax: scatterYMax, majorIncrement: scatterYAxisModel.interval)
    }

    private func updateXAxisLabels(space: CPTXYPlotSpace) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet,
              let xAxis = axisSet.xAxis,
              let series = viewModel.series.first else {
            return
        }

        var xLabels = Set<CPTAxisLabel>()
        let _ = space.xRange.maxLimitDouble - space.xRange.minLimitDouble

        func insertLabelToXLabels(date: Date, dataLocation: Double) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d"
            let text = dateFormatter.string(from: date)
            let label = CPTAxisLabel(text: text, textStyle: textStyle)
            label.tickLocation = NSNumber(value: Float(dataLocation))
            label.offset = 5
            label.alignment = .center
            xLabels.insert(label)
        }

        guard let firstPoint = series.data.first,
              let lastPoint = series.data.last,
              let firstDate = try? dateTransformer.utcDate(from: firstPoint.xAxis, format: dateTransformer.dateFormat),
              let lastDate = try? dateTransformer.utcDate(from: lastPoint.xAxis, format: dateTransformer.dateFormat) else {
            return
        }

        let components = calendar.dateComponents([.day], from: firstDate, to: lastDate)
        let totalDays = CGFloat(components.day ?? 0)

        let firstLocation = Double(getXLocation(for: firstDate))
        insertLabelToXLabels(date: firstDate, dataLocation: firstLocation)

        let lastLocation = Double(getXLocation(for: lastDate))
        insertLabelToXLabels(date: lastDate, dataLocation: lastLocation)

        let middleLabelCount = min(3, series.data.count - 2)

        if middleLabelCount > 0 {
            let dayInterval = totalDays / CGFloat(middleLabelCount + 1)
            for i in 1...middleLabelCount {
                let daysToAdd = CGFloat(i) * dayInterval
                let currentDate = firstDate.add(day: Int(daysToAdd))
                let location = Double(getXLocation(for: currentDate))
                insertLabelToXLabels(date: currentDate, dataLocation: location)
            }
        }

        xAxis.axisLabels = nil
        xAxis.axisLabels = xLabels
    }

    private func configureYAxisLabels(yMin: Float, yMax: Float, majorIncrement: Float) {
        guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet, let space = hostView.hostedGraph?.defaultPlotSpace as? CPTXYPlotSpace else {
            return
        }

        if let yAxis = axisSet.yAxis {
            let chartYMax = getChartYMax(yMax: yMax, yMin: yMin)
            var yLabels = Set<CPTAxisLabel>()
            var yMajorLocations = Set<NSNumber>()

            space.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(chartYMax))
            space.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromFloat(yMin), lengthDecimal: CPTDecimalFromFloat(chartYMax))

            for index in stride(from: yMin, to: yMax + majorIncrement, by: majorIncrement) {
                let labelText = "\(index)"
                let label = CPTAxisLabel(text: labelText, textStyle: textStyle)
                let location = CPTDecimalFromFloat(index)
                label.tickLocation = location as NSNumber
                label.alignment = .right
                label.offset = 10
                yLabels.insert(label)
                yMajorLocations.insert(location as NSNumber)
            }

            yAxis.axisLabels = yLabels
            yAxis.majorTickLocations = yMajorLocations
        }
    }

    private func getChartYMax(yMax: Float, yMin: Float) -> Float {
        return (yMax - yMin) * 6 / 5
    }

    private func getChartUnitYSite(yMax: Float, yMin: Float) -> Float {
        return (yMax - yMin) * 8 / 7
    }

    private func getWidthPoint() -> CGFloat {
        guard let series = viewModel.series.first,
              let firstPoint = series.data.first,
              let lastPoint = series.data.last,
              let firstDate = try? dateTransformer.utcDate(from: firstPoint.xAxis, format: dateTransformer.dateFormat),
              let lastDate = try? dateTransformer.utcDate(from: lastPoint.xAxis, format: dateTransformer.dateFormat) else {
            return hostViewWidth / 5 // 默認值
        }
        
        let components = calendar.dateComponents([.day], from: firstDate, to: lastDate)
        let totalDays = CGFloat(components.day ?? 0)
        return hostViewWidth / max(1, totalDays) // 確保不會除以0
    }

    private func getXLocation(for date: Date) -> CGFloat {
        guard let series = viewModel.series.first,
              let firstPoint = series.data.first,
              let lastPoint = series.data.last,
              let firstDate = try? dateTransformer.utcDate(from: firstPoint.xAxis, format: dateTransformer.dateFormat),
              let lastDate = try? dateTransformer.utcDate(from: lastPoint.xAxis, format: dateTransformer.dateFormat) else {
            return 0
        }
        
        let components = calendar.dateComponents([.day], from: firstDate, to: date)
        let days = CGFloat(components.day ?? 0)
        let totalDays = CGFloat(calendar.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0)
        let xPadding = hostViewWidth * 0.01 // 左右各留 1% 的空間
        let availableWidth = hostViewWidth - xPadding * 2
        return xPadding + (days / totalDays) * availableWidth
    }
    
    private func fetchAxisRange(min: Float, max: Float, axisCount: Int, ignoreFloatScale: Bool = true, isStep: Bool = false) -> AxisScaleModel {
        let finalMax = ceil(max)
        var finalMin = floor(min)

        let diff = finalMax - finalMin

        let spaceFloat = Float(axisCount)

        if ignoreFloatScale == false && 1 * diff < 0.5 * spaceFloat {
            finalMin = finalMax - 0.5 * spaceFloat < 0 ? 0 : finalMax - 0.5 * spaceFloat
            return AxisScaleModel(min: finalMin, interval: 0.5)
        }

        let axisArray1: [Float] = [1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 40]
        let axisArray2: [Float] = isStep ? Array(stride(from: 50, through: 40000, by: 50)) : Array(stride(from: 50, through: 500, by: 50))
        let axisArray = axisArray1 + axisArray2

        for axis in axisArray where finalMax - finalMin < axis * spaceFloat {
            var axisMin = finalMin
            if axis > axisMin {
                axisMin = axis - axis
            } else if axisMin == min {
                axisMin -= axis
            }
            // 如果最大值沒辦法超過中線、可以讓最小值再減一個格距、這樣圖看起來才不會偏下
            if finalMax <= axis * (spaceFloat / 2) + axisMin {
                axisMin -= axis
            }

            // finalMin - Float(Int(finalMin) % Int(axis)) 可以讓yAxis的刻度變好看
            axisMin -= Float(Int(axisMin) % Int(axis))
            axisMin = axisMin < 0 ? 0 : axisMin
            let yAxisMaxValue = axis * spaceFloat + axisMin

            if finalMax <= yAxisMaxValue {
                return AxisScaleModel(min: axisMin, interval: axis)
            }
        }

        return AxisScaleModel(min: finalMin, interval: 50)
    }

}

extension LineChartView: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        guard let series = viewModel.series.first else { return 0 }
        return UInt(series.data.count)
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)),
              let series = viewModel.series.first else {
            return nil
        }
        
        let point = series.data[Int(idx)]
        
        switch field {
        case .X:
            guard let date = try? dateTransformer.utcDate(from: point.xAxis, format: dateTransformer.dateFormat) else {
                return nil
            }
            let location = getXLocation(for: date)
            return location
        case .Y:
            guard let value = Float(point.yAxis) else {
                return nil
            }
            return value
        @unknown default:
            return nil
        }
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }

    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }

}

extension LineChartView: CPTPlotSpaceDelegate {

    func plotSpace(_ space: CPTPlotSpace, shouldScaleBy interactionScale: CGFloat, aboutPoint interactionPoint: CGPoint) -> Bool {
        return false
    }

    func plotSpace(_ space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, for coordinate: CPTCoordinate) -> CPTPlotRange? {
        switch coordinate {
        case .X:
            return newRange
        case .Y:
            let space = space as? CPTXYPlotSpace
            return space?.globalYRange
        default:
            return nil
        }
    }

    func plotSpace(_ space: CPTPlotSpace, didChangePlotRangeFor coordinate: CPTCoordinate) {
        guard let space = space as? CPTXYPlotSpace else {
            return
        }
        updateXAxisLabels(space: space)
    }
}

extension LineChartView: CPTScatterPlotDataSource {
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        return CPTPlotSymbol.normalScatterSymbol()
    }
}

