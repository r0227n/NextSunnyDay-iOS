//
//  NextSunnyDayViewModel.swift
//  NextSunnyDay
//
//  Created by rMac on 2020/10/13.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI

// MARK: - NextSunnyDayViewModelObject
protocol NextSunnyDayViewModelObject: ViewModelObject where Input: NextSunnyDayViewModelInputObject, Binding: NextSunnyDayViewModelBindingObject, Output: NextSunnyDayViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get }
    var output: Output { get }
}

// MARK: - NextSunnyDayViewModelInputObject
protocol NextSunnyDayViewModelInputObject: InputObject {
}

// MARK: - NextSunnyDayViewModelBindingObject
protocol NextSunnyDayViewModelBindingObject: BindingObject {
}

// MARK: - NextSunnyDayViewModelOutputObject
protocol NextSunnyDayViewModelOutputObject: OutputObject {
    var backgroundColor: LinearGradient { get }
    var textColor: Color { get }
    var cityName: String { get }
    var nextSunnyDay: String { get }
    var maxTemperature: String { get }
    var minTemperature: String { get }
}

// MARK: - NextSunnyDayViewModel
class NextSunnyDayViewModel: NextSunnyDayViewModelObject {
    final class Input: NextSunnyDayViewModelInputObject {}

    final class Binding: NextSunnyDayViewModelBindingObject {}

    final class Output: NextSunnyDayViewModelOutputObject {
        @Published var backgroundColor: LinearGradient = .noNextSunnyDayBackground
        @Published var textColor: Color = .white
        @Published var cityName = ""
        @Published var nextSunnyDay = R.string.nextSunnyDay.nextWeekOnwards()
        @Published var maxTemperature = R.string.nextSunnyDay.hyphen()
        @Published var minTemperature = R.string.nextSunnyDay.hyphen()
    }

    var input: Input

    var binding: Binding

    var output: Output

    init(_ forecast: DailyWeatherForecastEntity) {
        let input = Input()
        let binding = Binding()
        let output = Output()

        // output
        output.cityName = forecast.cityName
        if let nearestSunnyDay = forecast.daily.filter({ WeatherConditionCode.sunnyCodes.contains($0.weather.first?.id ?? 0) }).min(by: { $0.date < $1.date }) {
            output.backgroundColor = .nextSunnyDayBackground
            output.textColor = Color(R.color.nextSunnyDayText() ?? .white)
            output.nextSunnyDay = Date(timeIntervalSince1970: Double(nearestSunnyDay.date)).format(text: "M/d (EEE)")
            if let temp = nearestSunnyDay.temp {
                output.maxTemperature = String("\(temp.max)℃")
                output.minTemperature = String("\(temp.min)℃")
            }
        }

        self.input = input
        self.binding = binding
        self.output = output
    }
}
