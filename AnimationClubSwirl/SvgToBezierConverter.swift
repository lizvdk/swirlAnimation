//
//  SvgToBezierConverter.swift
//  AnimationClubSwirl
//
//  SVG Converter by Nate Cook: http://nshipster.com/nsscanner/
//  Used with permission
//

import UIKit

public class SvgToBezierConverter {

    func bezierPathFromSVGPath(str: String, orgSize: CGRect, newSize: CGRect) -> UIBezierPath {
        let scanner = NSScanner(string: str)

        // skip commas and whitespace
        let skipChars = NSMutableCharacterSet(charactersInString: ",")
        skipChars.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        scanner.charactersToBeSkipped = skipChars

        // the resulting bezier path
        let path = UIBezierPath()

        // instructions code can be upper- or lower-case
        let instructionSet = NSCharacterSet(charactersInString: "MCSQTAmcsqta")
        var instruction: NSString?

        // scan for an instruction code
        while scanner.scanCharactersFromSet(instructionSet, intoString: &instruction) {
            var x = 0.0, y = 0.0
            var points: [CGPoint] = []

            // scan for pairs of Double, adding them as CGPoints to the points array
            while scanner.scanDouble(&x) && scanner.scanDouble(&y) {
                let adjustedX = (x / Double(orgSize.width)) * Double (newSize.width)
                let adjustedY = (y / Double(orgSize.height)) * Double(newSize.height)

                points.append(CGPoint(x: adjustedX, y: adjustedY))
            }

            // new point for bezier path
            switch instruction ?? "" {
            case "M":
                path.moveToPoint(points[0])
            case "C":
                path.addCurveToPoint(points[2], controlPoint1: points[0], controlPoint2: points[1])
            case "c":
                path.addCurveToPoint(path.currentPoint.offset(points[2]),
                                     controlPoint1: path.currentPoint.offset(points[0]),
                                     controlPoint2: path.currentPoint.offset(points[1]))
            default:
                break
            }
        }

        return path
    }

}

extension CGPoint {
    func offset(p: CGPoint) -> CGPoint {
        return CGPoint(x: x + p.x, y: y + p.y)
    }
}
