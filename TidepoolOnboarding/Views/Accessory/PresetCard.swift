//
//  PresetCard.swift
//  TidepoolOnboarding
//
//  Created by Cameron Ingham on 1/21/26.
//

import LoopAlgorithm
import LoopKitUI
import SwiftUI

struct DefaultPresetCard: View {
    
    @EnvironmentObject private var displayGlucosePreference: DisplayGlucosePreference
    
    let systemSymbolName: String
    let name: Text
    let duration: TimeInterval
    let overallInsulinPercentage: Double
    let correctionRange: ClosedRange<LoopQuantity>
    
    private var presetTitle: some View {
        HStack(spacing: 6) {
            Text(Image(systemName: systemSymbolName))
                .fontDesign(.monospaced)

            name
                .fontWeight(.semibold)
            
            Text(Image(systemName: "checkmark.seal.fill"))
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
        }
    }
    
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter
    }()
    
    @ViewBuilder
    private var presetDuration: some View {
        Group { Text(Image(systemName: "timer")) + Text(" \(durationFormatter.string(from: duration) ?? "")") }
            .font(.footnote)
            .foregroundColor(.secondary)
    }
    
    private var overallInsulinView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overall Insulin")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(alignment: .top) {
                Group { Text(overallInsulinPercentage.formatted(.percent)).bold() + Text(" of scheduled") }
                    .font(.subheadline)
            }
        }
    }
   
    @ViewBuilder
    private var correctionRangeView: some View {
        let units = Text(" \(displayGlucosePreference.unit.localizedUnitString(in: .medium) ?? displayGlucosePreference.unit.unitString)")
        let lower = Text(displayGlucosePreference.format(correctionRange.lowerBound, includeUnit: false))
            .bold()
        let upper = Text(displayGlucosePreference.format(correctionRange.upperBound, includeUnit: false))
            .bold()
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Correction Range")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Group {
                lower + Text(" - ") + upper + units
            }
            .font(.subheadline)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    presetTitle
                    Spacer()
                    presetDuration
                }
            }
            
            Divider()
                .padding(.horizontal, -10)
            
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 0) {
                    overallInsulinView
                    Spacer()
                    correctionRangeView
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8)
        .fill(Color(UIColor.tertiarySystemBackground))
        .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 1)
        .frame(maxWidth: .infinity))
    }
}
