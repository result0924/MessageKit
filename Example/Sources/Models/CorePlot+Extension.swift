//
//  CorePlot+Extension.swift
//  ChatExample
//
//  Created by Justin Lai on 2025/4/28.
//  Copyright © 2025 MessageKit. All rights reserved.
//

import CorePlot

extension CPTMutableTextStyle {
    static func dashBoardTextStyle() -> CPTMutableTextStyle {
        return makeTextStyle(color: CPTColor.gray600(), fontSize: 12)
    }

    static func makeTextStyle(color: CPTColor, fontSize: CGFloat) -> CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = color
        textStyle.fontSize = fontSize
        textStyle.textAlignment = .center
        return textStyle
    }
}

extension CPTColor {
    class func gray300() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor)
    }
    
    static func gray500() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 135 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1).cgColor)
    }
    
    static func gray600() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1).cgColor)
    }
    
    static func dashboardNormal() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor)
    }
}

extension CPTMutableLineStyle {
    static func makeLineStyle(lineWidth: CGFloat, lineColor: CPTColor) -> CPTMutableLineStyle {
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = lineWidth
        axisLineStyle.lineColor = lineColor
        return axisLineStyle
    }
}

extension CPTPlotSymbol {
    static func makeScatterSymbol(color: CPTColor) -> CPTPlotSymbol {
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 3
        symbolLineStyle.lineColor = color

        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = CPTFill(color: CPTColor.gray300())
        symbol.lineStyle = symbolLineStyle
        symbol.size = CGSize(width: 3, height: 3)

        return symbol
    }

    static func normalScatterSymbol() -> CPTPlotSymbol {
        return makeScatterSymbol(color: CPTColor.dashboardNormal())
    }

}

extension CPTColor {
    static func chartBlue(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cBlue(alpha: alpha).cgColor)
    }
    
    static func chartRed(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cRed(alpha: alpha).cgColor)
    }
    
    static func chartGreen(alpha: CGFloat) -> CPTColor {
        return CPTColor(cgColor: UIColor.cGreen(alpha: alpha).cgColor)
    }
}

extension UIColor {
    class func scatterLineColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1).cgColor)
    }
    
    class func chartXAxisTextColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1).cgColor)
    }
    
    class func chartYAxisTextColor() -> CPTColor {
        return CPTColor(cgColor: UIColor(red: 166 / 255, green: 166 / 255, blue: 166 / 255, alpha: 1).cgColor)
    }
    
    class func paleGrayColor() -> UIColor {
        return UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
    }
    
    static func cGreen(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 43 / 255, green: 181 / 255, blue: 155 / 255, alpha: alpha)
    }
    
    static func cBlue(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 0.16, green: 0.53, blue: 0.87, alpha: alpha)
    }
    
    static func cRed(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 1, green: 0.51, blue: 0.41, alpha: alpha)
    }
}
