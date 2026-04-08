import Foundation
import Testing
@testable import BioStats

@Test func vespriumCalendarConstants() {
    #expect(VespriumCalendar.daysPerWeek == 7)
    #expect(VespriumCalendar.weeksPerMonth == 4)
    #expect(VespriumCalendar.daysPerMonth == 28)
    #expect(VespriumCalendar.monthsPerYear == 10)
    #expect(VespriumCalendar.daysPerYear == 280)
}

@Test func weekdayAndMonthDisplayNamesAreNonEmpty() {
    for w in Weekday.allCases {
        #expect(!w.displayName.isEmpty)
    }
    for m in VespriumMonth.allCases {
        #expect(!m.displayName.isEmpty)
    }
}

@Test func vespriumDateInitRejectsInvalidDay() {
    #expect(VespriumDate(year: 1, month: .thaw, day: 0) == nil)
    #expect(VespriumDate(year: 1, month: .thaw, day: 29) == nil)
}

@Test func epochDateIsZeroDaysAndYieldsThawFirst() {
    let d = VespriumDate(daysSinceEpoch: 0)
    #expect(d.year == 1)
    #expect(d.month == .thaw)
    #expect(d.day == 1)
    #expect(VespriumDate(year: 1, month: .thaw, day: 1)?.daysSinceEpoch == 0)
}

@Test func roundTripYMDForSeveralDates() {
    let samples: [(Int, VespriumMonth, Int)] = [
        (1, .thaw, 28),
        (1, .stir, 1),
        (3, .deep, 28),
        (42, .haze, 14)
    ]
    for (y, m, day) in samples {
        let date = VespriumDate(year: y, month: m, day: day)!
        #expect(date.year == y)
        #expect(date.month == m)
        #expect(date.day == day)
    }
}

@Test func endOfMonthRollsToNextMonth() {
    let lastOfThaw = VespriumDate(year: 5, month: .thaw, day: 28)!
    let firstOfStir = lastOfThaw.adding(days: 1)
    #expect(firstOfStir.year == 5)
    #expect(firstOfStir.month == .stir)
    #expect(firstOfStir.day == 1)
}

@Test func endOfYearRollsToNextYear() {
    let lastOfYear = VespriumDate(year: 7, month: .deep, day: 28)!
    let firstNext = lastOfYear.adding(days: 1)
    #expect(firstNext.year == 8)
    #expect(firstNext.month == .thaw)
    #expect(firstNext.day == 1)
}

@Test func addingNegativeDaysCrossesMonthBoundary() {
    let firstOfStir = VespriumDate(year: 2, month: .stir, day: 1)!
    let lastOfThaw = firstOfStir.adding(days: -1)
    #expect(lastOfThaw.year == 2)
    #expect(lastOfThaw.month == .thaw)
    #expect(lastOfThaw.day == 28)
}

@Test func addingNegativeDaysCrossesYearBoundary() {
    let firstOfYear = VespriumDate(year: 4, month: .thaw, day: 1)!
    let lastPrior = firstOfYear.adding(days: -1)
    #expect(lastPrior.year == 3)
    #expect(lastPrior.month == .deep)
    #expect(lastPrior.day == 28)
}

@Test func daysSinceIsAntisymmetric() {
    let a = VespriumDate(year: 1, month: .thaw, day: 1)!
    let b = VespriumDate(year: 2, month: .deep, day: 14)!
    #expect(a.daysSince(b) == -b.daysSince(a))
    #expect(a.daysSince(a) == 0)
    #expect(b.daysSince(b) == 0)
}

@Test func weekdayWithEpochForge() {
    let epochWeekday = Weekday.forge
    let d0 = VespriumDate(daysSinceEpoch: 0)
    #expect(d0.weekday(assumingEpochDayIs: epochWeekday) == .forge)
    #expect(VespriumDate(daysSinceEpoch: 1).weekday(assumingEpochDayIs: epochWeekday) == .weave)
    #expect(VespriumDate(daysSinceEpoch: 6).weekday(assumingEpochDayIs: epochWeekday) == .mend)
    #expect(VespriumDate(daysSinceEpoch: 7).weekday(assumingEpochDayIs: epochWeekday) == .forge)
}

@Test func weekdaySeventhDayOfYearMatchesSeventhCalendarDay() {
    // Seventh day of year 1 is still in Thaw: day 7.
    let seventh = VespriumDate(year: 1, month: .thaw, day: 7)!
    #expect(seventh.daysSinceEpoch == 6)
    #expect(seventh.weekday(assumingEpochDayIs: .forge) == VespriumDate(daysSinceEpoch: 6).weekday(assumingEpochDayIs: .forge))
}

@Test func vespriumDateCodableRoundTrip() throws {
    let original = VespriumDate(year: 9, month: .ember, day: 15)!
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(VespriumDate.self, from: data)
    #expect(decoded == original)
}

@Test func weekdayAndMonthCodableRoundTrip() throws {
    let w = Weekday.graft
    let m = VespriumMonth.veil
    let wd = try JSONDecoder().decode(Weekday.self, from: try JSONEncoder().encode(w))
    let md = try JSONDecoder().decode(VespriumMonth.self, from: try JSONEncoder().encode(m))
    #expect(wd == w)
    #expect(md == m)
}

@Test func comparableOrdersByDaysSinceEpoch() {
    let a = VespriumDate(year: 1, month: .thaw, day: 1)!
    let b = VespriumDate(year: 1, month: .thaw, day: 2)!
    #expect(a < b)
    #expect(!(b < a))
}

@Test func negativeDaysSinceEpochMapsToEarlierYear() {
    let d = VespriumDate(daysSinceEpoch: -1)
    #expect(d.year == 0)
    #expect(d.month == .deep)
    #expect(d.day == 28)
}
