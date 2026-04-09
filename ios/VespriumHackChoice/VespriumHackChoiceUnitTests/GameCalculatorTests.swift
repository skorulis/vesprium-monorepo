import BioStats
import Testing
@testable import VespriumHackChoice

@MainActor
struct GameCalculatorTests {

    @Test func weaknessChanceIsZeroAtAgeTwentyAndBelow() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.vitality] = 0

        let age20Date = VespriumDate(year: 40, month: .stir, day: 1)!
        let age19Date = VespriumDate(year: 39, month: .stir, day: 1)!

        #expect(GameCalculator(player: player).weaknessChance(on: age20Date) == 0)
        #expect(GameCalculator(player: player).weaknessChance(on: age19Date) == 0)
    }

    @Test func weaknessChanceReachesHundredAtAgeOneHundred() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.vitality] = 0

        let age100Date = VespriumDate(year: 120, month: .stir, day: 1)!
        #expect(GameCalculator(player: player).weaknessChance(on: age100Date) == 100)
    }

    @Test func weaknessChanceScalesLinearlyAndSubtractsVitality() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.vitality] = 10

        let age60Date = VespriumDate(year: 80, month: .stir, day: 1)!
        // Age 60 -> base 50, then -10 vitality.
        #expect(GameCalculator(player: player).weaknessChance(on: age60Date) == 40)
    }

    @Test func weaknessChanceClampsAfterVitalitySubtraction() {
        var resilientPlayer = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        resilientPlayer.attributes[.vitality] = 80
        let age60Date = VespriumDate(year: 80, month: .stir, day: 1)!
        #expect(GameCalculator(player: resilientPlayer).weaknessChance(on: age60Date) == 0)

        var olderPlayer = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        olderPlayer.attributes[.vitality] = 15
        let age120Date = VespriumDate(year: 140, month: .stir, day: 1)!
        // Base chance clamps to 100 before vitality subtraction.
        #expect(GameCalculator(player: olderPlayer).weaknessChance(on: age120Date) == 85)
    }

    @Test func monthlyLivingExpensesBreakdownUsesFoodAndHousingFormulas() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.strength] = 12
        let breakdown = GameCalculator(player: player).monthlyLivingExpensesBreakdown()
        #expect(breakdown.food == 32)
        #expect(breakdown.housing == 30)
        #expect(breakdown.total == 62)
    }

    @Test func monthlyBalanceChangeSubtractsLivingExpensesFromCardNet() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.strength] = 12
        player.attributes[.vitality] = 10
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.gym)
            ]
        )
        let net = GameCalculator(player: player).monthlyBalanceChange()
        #expect(net == 82)
    }
}
