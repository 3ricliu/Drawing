//
//  ContentView.swift
//  Drawing
//
//  Created by Eric Liu on 10/25/20.
//

import SwiftUI

//struct Trapezoid: Shape {
//  var insetAmount: CGFloat
//
//  var animatableData: CGFloat {
//    get { insetAmount }
//    set { self.insetAmount = newValue }
//  }
//
//  func path(in rect: CGRect) -> Path {
//    var path = Path()
//
//    path.move(to: CGPoint(x: 0, y: rect.maxY))
//    path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
//    path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
//    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//    path.addLine(to: CGPoint(x: 0, y: rect.maxY))
//
//    return path
//  }
//}

struct ColorCyclingRectangle: View {
  var amount = 0.0
  var steps = 100
  
  var body: some View {
    ZStack {
      ForEach(0..<steps) { value in
        Rectangle()
          .inset(by: CGFloat(value))
          .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
      }
    }
  }

  func color(for value: Int, brightness: Double) -> Color {
    var targetHue = Double(value) / Double(self.steps) + self.amount
    
    if targetHue > 1 {
      targetHue -= 1
    }
    
    return Color(hue: targetHue, saturation: 1, brightness: brightness)
  }
}

struct Rectangle: InsettableShape {
  var insetAmount: CGFloat = 0
  
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: 100, y: 300))
    path.addLine(to: CGPoint(x: 100 + insetAmount, y: 300 + insetAmount))
    path.addLine(to: CGPoint(x: 200 + insetAmount, y: 300  + insetAmount))
    path.addLine(to: CGPoint(x: 200 + insetAmount, y: 0 + insetAmount))
    path.addLine(to: CGPoint(x: 100 + insetAmount, y: 0 + insetAmount))
    path.addLine(to: CGPoint(x: 100 + insetAmount, y: 300 + insetAmount))
  
    return path
  }
  
  func inset(by amount: CGFloat) -> some InsettableShape {
    var rect = self
    rect.insetAmount += amount
    return rect
  }
}

struct Arrow: Shape {

  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: 0, y: rect.maxY))
    path.addLine(to: CGPoint(x: 100, y: rect.minY))
    path.addLine(to: CGPoint(x: 200, y: rect.maxY))

    return path
  }
}

struct AdjustableRectangle: Shape {
  var insetAmount: CGFloat
  
  var animatableData: CGFloat {
    get { insetAmount }
    set { self.insetAmount = newValue }
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: 100, y: 0))
    path.addLine(to: CGPoint(x: 100, y: rect.maxY + insetAmount))
  
    return path
  }
}

struct ContentView: View {
  @State private var insetAmount: CGFloat = 0
  @State private var colorCycle = 0.0

  var body: some View {
//    Trapezoid(insetAmount: insetAmount)
//      .frame(width: 200, height: 100)
//      .onTapGesture {
//        withAnimation {
//          self.insetAmount = CGFloat.random(in: 10...90)
//        }
//      }
    VStack {
      Arrow()
        .frame(width: 200, height: 100)
      AdjustableRectangle(insetAmount: insetAmount)
        .stroke(Color.black, style: StrokeStyle(lineWidth: 50 + insetAmount))
        .frame(width: 200, height: 100)
        .onTapGesture {
          withAnimation{
            self.insetAmount += 10
          }
        }
      ColorCyclingRectangle(amount: self.colorCycle)
        .frame(width: 300, height: 300)
      
      Slider(value: $colorCycle)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
