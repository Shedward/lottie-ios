//
//  TestImageProvider.swift
//  lottie-swift_Example
//
//  Created by Vladislav Maltsev on 25.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Lottie

class TestAnimationImageProvider: AnimationImageProvider {
  func imageForAsset(asset: ImageAsset) -> CGImage? {
    let size = CGSize(width: asset.width, height: asset.height)
    let color = hashColor(for: asset.name.hashValue)
    UIGraphicsBeginImageContext(size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.setFillColor(color.cgColor)
    let strokeColor = invertColor(color)
    context.setStrokeColor(strokeColor.cgColor)
    context.setLineWidth(4.0)

    let rect = CGRect(origin: .zero, size: size)
    context.fill(rect)
    context.stroke(rect)
    let shapeRect = rect.inset(by: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))
    drawShape(rect: shapeRect, in: context, of: strokeColor)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image?.cgImage
  }

  private func hashColor(for hash: Int) -> UIColor {
    let normalizedHash = CGFloat(Double(UInt.max) / Double(UInt(abs(hash))))
    return UIColor(hue: normalizedHash, saturation: 1.0, brightness: 1.0, alpha: 1.0)
  }

  private func invertColor(_ color: UIColor) -> UIColor {
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    if hue < 0.5 {
      hue += 0.5
    } else {
      hue -= 0.5
    }
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }

  private func drawShape(rect: CGRect, in context: CGContext, of color: UIColor) {
    func drawRect(x: Int, y: Int, text: String) {
      let rect = CGRect(
        x: rect.minX + CGFloat(x) * 0.25 * rect.width,
        y: rect.minY + CGFloat(y) * 0.25 * rect.height,
        width: 0.25 * rect.width,
        height: 0.25 * rect.height
      )
      NSAttributedString(
        string: text,
        attributes: [
            .font: UIFont.systemFont(ofSize: rect.height),
            .foregroundColor: color
        ]
      ).draw(in: rect)
      context.stroke(rect)
    }

    drawRect(x: 0, y: 0, text: "A")
    drawRect(x: 1, y: 0, text: "B")
    drawRect(x: 2, y: 0, text: "C")
    drawRect(x: 3, y: 0, text: "D")
    drawRect(x: 3, y: 1, text: "E")
    drawRect(x: 0, y: 2, text: "F")
    drawRect(x: 0, y: 3, text: "G")
    drawRect(x: 3, y: 3, text: "H")
  }
}
