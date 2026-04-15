// Created by Alex Skorulis on 14/4/2026.

import Foundation
import SwiftUI

struct CooldownPieView: View {
    let remainingFraction: Double

    var body: some View {
        GeometryReader { proxy in
            CooldownPieSlice(
                fraction: remainingFraction
            )
            .fill(.black.opacity(0.45))
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CooldownPieSlice: Shape {
    let fraction: Double

    func path(in rect: CGRect) -> Path {
        guard fraction > 0 else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height)
        let start = Angle.degrees(-90)
        let end = Angle.degrees(-90 + (360 * fraction))

        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        path.closeSubpath()
        return path
    }
}
