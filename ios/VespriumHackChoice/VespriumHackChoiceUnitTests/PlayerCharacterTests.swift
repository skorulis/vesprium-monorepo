import Foundation
import Testing
@testable import VespriumHackChoice

private let testCalendar: Calendar = {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(secondsFromGMT: 0)!
    return cal
}()

private func date(year: Int, month: Int, day: Int) -> Date {
    testCalendar.date(from: DateComponents(year: year, month: month, day: day))!
}

@Test func defaultJobIsFarming() {
    let dob = date(year: 2000, month: 6, day: 15)
    let player = PlayerCharacter(dateOfBirth: dob)
    #expect(player.job == .farming)
}

@Test func ageOnBirthday() {
    let dob = date(year: 2000, month: 3, day: 15)
    let player = PlayerCharacter(dateOfBirth: dob)
    let now = date(year: 2020, month: 3, day: 15)
    #expect(player.ageInFullYears(on: now, calendar: testCalendar) == 20)
}

@Test func ageDayBeforeBirthdayIsOneYearLess() {
    let dob = date(year: 2000, month: 3, day: 15)
    let player = PlayerCharacter(dateOfBirth: dob)
    let now = date(year: 2020, month: 3, day: 14)
    #expect(player.ageInFullYears(on: now, calendar: testCalendar) == 19)
}

@Test func ageNegativeWhenGameDateBeforeBirth() {
    let dob = date(year: 2000, month: 1, day: 1)
    let player = PlayerCharacter(dateOfBirth: dob)
    let now = date(year: 1999, month: 12, day: 31)
    #expect(player.ageInFullYears(on: now, calendar: testCalendar) == 0)
}

@Test func gameStateHoldsCurrentDate() {
    let d = date(year: 2026, month: 4, day: 7)
    let state = GameState(currentGameDate: d)
    #expect(state.currentGameDate == d)
}

@Test func ageUsesGameStateCurrentDate() {
    let dob = date(year: 2000, month: 1, day: 1)
    let player = PlayerCharacter(dateOfBirth: dob)
    let state = GameState(currentGameDate: date(year: 2026, month: 1, day: 1))
    #expect(player.ageInFullYears(on: state.currentGameDate, calendar: testCalendar) == 26)
}
