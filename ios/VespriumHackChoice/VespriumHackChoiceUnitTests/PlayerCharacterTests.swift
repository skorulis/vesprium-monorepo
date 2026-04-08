import BioStats
import Testing
@testable import VespriumHackChoice

@MainActor
struct PlayerCharacterTests {
    @Test func defaultPlayerHasNoJob() {
        let dob = VespriumDate(year: 20, month: .surge, day: 15)!
        let player = PlayerCharacter(dateOfBirth: dob)
        #expect(player.job == nil)
    }

    @Test func ageOnBirthday() {
        let dob = VespriumDate(year: 20, month: .stir, day: 15)!
        let player = PlayerCharacter(dateOfBirth: dob)
        let now = VespriumDate(year: 40, month: .stir, day: 15)!
        #expect(player.ageInFullYears(on: now) == 20)
    }

    @Test func ageDayBeforeBirthdayIsOneYearLess() {
        let dob = VespriumDate(year: 20, month: .stir, day: 15)!
        let player = PlayerCharacter(dateOfBirth: dob)
        let now = VespriumDate(year: 40, month: .stir, day: 14)!
        #expect(player.ageInFullYears(on: now) == 19)
    }

    @Test func ageNegativeWhenGameDateBeforeBirth() {
        let dob = VespriumDate(year: 20, month: .thaw, day: 1)!
        let player = PlayerCharacter(dateOfBirth: dob)
        let now = VespriumDate(year: 19, month: .deep, day: 28)!
        #expect(player.ageInFullYears(on: now) == 0)
    }

    @Test func gameStateHoldsCurrentDate() {
        let d = VespriumDate(year: 42, month: .surge, day: 7)!
        let state = GameState(currentGameDate: d)
        #expect(state.currentGameDate == d)
    }

    @Test func ageUsesGameStateCurrentDate() {
        let dob = VespriumDate(year: 20, month: .thaw, day: 1)!
        let player = PlayerCharacter(dateOfBirth: dob)
        let state = GameState(currentGameDate: VespriumDate(year: 46, month: .thaw, day: 1)!)
        #expect(player.ageInFullYears(on: state.currentGameDate) == 26)
    }
}
