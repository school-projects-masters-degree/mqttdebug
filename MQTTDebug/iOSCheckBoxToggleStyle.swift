//
//  iOSCheckBoxToggleStyle.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 17.12.23.
// https://sarunw.com/posts/swiftui-checkbox/

import SwiftUI

struct iOSCheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {

            configuration.isOn.toggle()

        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                configuration.label
            }
        })
    }
}
