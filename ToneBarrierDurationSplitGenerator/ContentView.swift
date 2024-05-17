//
//  ContentView.swift
//  ToneBarrierDurationSplitGenerator
//
//  Created by Xcode Developer on 5/17/24.
//

import SwiftUI
import Combine
import Observation

struct ContentView: View {
    private var durations: Durations = Durations(length: nil, lowerBound: nil, upperBound: nil, tolerance: nil)
    @State private var results: [[[Double]]] = []
    @State private var scrollToBottom = false
    
    var body: some View {
        HStack(alignment: .bottom, content: {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, content: {
                    List(results, id: \.self) { result in
                        let diff = abs(result[0][0] - result[1][0])
                        let sum = result[0][0] + result[0][1]
                        
                        let formattedDiff = String(format: "- %.4f", diff)
                        let formattedSum  = String(format: "+ %.4f", sum)
                        
                        let diffColor = diff >= 0.3125 ? UIColor.green : UIColor.red
                        let sumColor = sum == 2.0000 ? UIColor.green : UIColor.red
                        
                        let firstDuration  = String(format: "  %.4f", result[0][0])
                        let secondDuration = String(format: "  %.4f", result[1][0])
                        
                        let text = NSMutableAttributedString(string: "\(firstDuration)\n\(secondDuration)\n")
                        
                        let coloredDiff = NSAttributedString(
                            string: formattedDiff,
                            attributes: [.foregroundColor: diffColor]
                        )
                        text.append(coloredDiff)
                        text.append(NSAttributedString(string: "\n"))
                        
                        let coloredSum = NSAttributedString(
                            string: formattedSum,
                            attributes: [.foregroundColor: sumColor]
                        )
                        text.append(coloredSum)
                        
                        return Text(AttributedString(text))
                            .id(result)
                            .padding()
                            .font(.body).monospaced().dynamicTypeSize(.small)
                    }
                    .onChange(of: scrollToBottom, {
                        if let lastItem = results.last {
                            withAnimation {
                                proxy.scrollTo(lastItem, anchor: .bottom)
                            }
                        }
                    })
                })
                
            }
            
            VStack(alignment: .trailing, content: {
                Button("Generate Random Durations") {
                    durations.randomizeDurationSplits { result in
                        results.append(result)
                        scrollToBottom.toggle()
                    }
                }
                .safeAreaPadding()
            })
            .safeAreaPadding()
            .border(.white)
        })
        .safeAreaPadding()
    }
}


extension View {
    func printOutput(_ value: Any) -> Self {
        print(value)
        return self
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
