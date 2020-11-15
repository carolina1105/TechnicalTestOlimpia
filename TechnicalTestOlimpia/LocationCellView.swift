//
//  LocationCellView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import MapKit

struct LocationCellView: View {
    private let lineWidth: CGFloat = 0.9
    private let two: Int = 2
    private let spacing: CGFloat = 10
    private let line: CGFloat = 1
    var location: LocationModel
    var didLocation: () -> Void
    
    var body: some View {
        return GeometryReader { geometry in
            Button(action: {
                self.didLocation()
            }) {
                VStack(spacing: .zero) {
                    HStack(spacing: self.spacing) {
                        if !(self.location.name?.isEmpty ?? false) {
                            Text(self.location.name!)
                                .lineLimit(self.two)
                                .foregroundColor(Color.tint)
                        }
                        if !(self.location.address?.isEmpty ?? false) {
                            Text(self.location.address!)
                                .lineLimit(self.two)
                                .foregroundColor(Color.primaryText)
                        }
                    }
                    .frame(width: geometry.size.width,
                           height: geometry.size.height - self.line)
                    Rectangle()
                        .frame(width: geometry.size.width * self.lineWidth,
                               height: self.line)
                        .foregroundColor(Color.primaryText)
                }
            }
        }
        .background(Color.backgroundDialog)
    }
}

struct LocationCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationCellView(location: LocationModel(name: "",
                                                 placemark: CLPlacemark())) {
                                                    
        }
    }
}
