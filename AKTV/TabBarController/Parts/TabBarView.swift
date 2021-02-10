//
//  TabBarView.swift
//  TabBarDevelopment
//
//  Created by Alexander Kvamme on 08/02/2021.
//

import UIKit

class TabBarView: UIView {

    // MARK: - Properties

    lazy var plusButton = RoundTabBarButton(frame: CGRect(x: screenWidth/2 - TabBarSettings.circleRadius, y: -TabBarSettings.barOffsetFromButton, width: TabBarSettings.circleRadius*2, height: TabBarSettings.circleRadius*2))
    lazy var button1 = makeButton(iconName: "paperclip")
    lazy var button2 = makeButton(iconName: "calendar")
    lazy var button3 = makeButton(iconName: "moon.fill")
    lazy var button4 = makeButton(iconName: "bookmark.fill")

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        addBackgroundBar()
        addFourButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Register touches on button even outside of TabBarView bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if plusButton.frame.contains(point) {
            return plusButton
        }

        return super.hitTest(point, with: event)
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .clear
    }

    // MARK: - Helper methods

    /// Masks the white background bar
    func addBackgroundBar() {
        let backgroundBarView = TabBarBackgroundView(frame: CGRect(origin: .zero, size: frame.size))
        backgroundBarView.backgroundColor = .clear
        backgroundBarView.layer.mask = makeNotchBasedMaskLayer()
        addSubview(backgroundBarView)
    }

    // Mask corners depending on notch size (if any)
    func makeNotchBasedMaskLayer() -> CALayer {
        let maskFrame = CGRect(x: 0, y: 0, width: screenWidth, height: TabBarSettings.barHeight)
        let maskView = UIView(frame: maskFrame)
        maskView.backgroundColor = .black // must have color to mask
        maskView.layer.cornerCurve = .continuous
        maskView.layer.maskedCorners = UIDevice.hasNotch ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : []
        maskView.layer.cornerRadius = TabBarSettings.cornerRadius
        return maskView.layer
    }
}

extension TabBarView {
    private func addFourButtons() {
        let iconHeight: CGFloat = 48
        let shiftAwayFromButton: CGFloat = 32
        let shiftInFromSides: CGFloat = 0
        let stackCenteringAjustment: CGFloat = 16

        let width = screenWidth/2 - stackCenteringAjustment*2 - shiftAwayFromButton
        let leftStackFrame = CGRect(x: stackCenteringAjustment + shiftInFromSides,
                                    y: TabBarSettings.sectionButtonTopOffset,
                                    width: width,
                                    height: iconHeight)
        let rightStackFrame = CGRect(x: frame.width/2 + stackCenteringAjustment - shiftInFromSides + shiftAwayFromButton,
                                     y: TabBarSettings.sectionButtonTopOffset,
                                     width: width,
                                     height: iconHeight)
        let leftStack = makeStack(frame: leftStackFrame)
        let rightStack = makeStack(frame: rightStackFrame)

        if debug {
            button3.backgroundColor = .red
            button4.backgroundColor = .cyan
            button2.backgroundColor = .blue
            button1.backgroundColor = .orange
        }

        leftStack.addArrangedSubview(button1)
        leftStack.addArrangedSubview(button2)
        rightStack.addArrangedSubview(button3)
        rightStack.addArrangedSubview(button4)

        addSubview(leftStack)
        addSubview(rightStack)
        addSubview(plusButton)
    }

    private func makeStack(frame: CGRect) -> UIStackView {
        let stack = UIStackView(frame: frame)
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.backgroundColor = debug ? .green : .clear
        stack.spacing = 8
        return stack
    }

    private func makeButton(iconName: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .black, scale: .large)
        let symbolImage = UIImage(systemName: iconName, withConfiguration: imageConfig)!
        button.setImage(symbolImage, for: .normal)
        button.tintColor = TabBarSettings.sectionButtonColor
        return button
    }
}

/// Used to draw the white tab bar background which includes a dip under the center button
class TabBarBackgroundView: UIView {
    static let controlPointWidth: CGFloat = 40

    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!

        let circleRadius = TabBarSettings.circleRadius
        let spacingUnderMainButton = TabBarSettings.spacingUnderMainButton
        let controlPointWidth = Self.controlPointWidth

        context.beginPath()

        let p = CGMutablePath()
        let screen = UIScreen.main.bounds
        let mid = CGPoint(x: screen.midX, y: screen.midY)
        let topLineY: CGFloat = 0
        let botLineY: CGFloat = frame.height

        let testCupping: CGFloat = 0
        let leftLineEnd = CGPoint(x: mid.x - controlPointWidth*2 + testCupping, y: topLineY)

        p.move(to: CGPoint(x: 0, y: 0))

        // Top Left curve
        p.addLine(to: leftLineEnd)

        let yUnderButton = topLineY + circleRadius + spacingUnderMainButton
        let rightLineEndPoint = CGPoint(x: p.currentPoint.x, y: topLineY)
        let topRight = CGPoint(x: frame.width, y: topLineY)
        let bottomRight = CGPoint(x: frame.width, y: botLineY)
        let bottomLeft = CGPoint(x: 0, y: frame.height)

        // Push control points a little extra horizontally
        let topControlPush: CGFloat = 8
        let botControlPush: CGFloat = 7

        // Curve going under button
        let c2 = CGPoint(x: mid.x - controlPointWidth + topControlPush, y: topLineY) // Curve control top left, going right
        let c3 = CGPoint(x: mid.x - controlPointWidth - botControlPush, y: yUnderButton) // Curve control botRight going left
        let p3 = CGPoint(x: mid.x, y: yUnderButton)
        p.addCurve(to: p3, control1: c2, control2: c3)

        // Curve coming up from under button
        let c4 = CGPoint(x: mid.x + controlPointWidth + botControlPush, y: yUnderButton)
        let c5 = CGPoint(x: mid.x + controlPointWidth - topControlPush, y: topLineY)
        let p4 = CGPoint(x: mid.x + controlPointWidth*2 - testCupping, y: topLineY)
        p.addCurve(to: p4, control1: c4, control2: c5)

        p.addLine(to: rightLineEndPoint)
        p.addLine(to: topRight)
        p.addLine(to: bottomRight)
        p.addLine(to: bottomLeft)

        // End and apply path
        p.closeSubpath()
        context.addPath(p)
        context.setFillColor(TabBarSettings.barColor.cgColor)
        context.fillPath()
    }
}
