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
        #expect(breakdown.activityCards == 0)
        #expect(breakdown.total == 62)
    }

    @Test func monthlyLivingExpensesBreakdownIncludesActivityCardCostsInTotal() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.attributes[.strength] = 12
        player.cards = PlayerCards(
            activities: [
                .activity(.gym)
            ]
        )
        let breakdown = GameCalculator(player: player).monthlyLivingExpensesBreakdown()
        #expect(breakdown.activityCards == 20)
        #expect(breakdown.total == 82)
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

    @Test func calculateStrainReturnsZeroAtSixteenBusyHours() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.school),
                .activity(.languages)
            ]
        )

        let strain = GameCalculator(player: player).calculateStrain()
        #expect(strain == Strain(physical: 0, mental: 0))
    }

    @Test func calculateStrainIncreasesWhenRestIsUnderEightHours() {
        var player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.school),
                .activity(.languages),
                .activity(.meditation)
            ]
        )

        let strain = GameCalculator(player: player).calculateStrain()
        #expect(strain == Strain(physical: 1, mental: 1))
    }

    @Test func calculateStrainValues() {
        let player = PlayerCharacter(dateOfBirth: VespriumDate(year: 20, month: .stir, day: 1)!)
        let calc = GameCalculator(player: player)
        #expect(calc.calculateTimeStrain(busyHours: 17).mental == 1)
        #expect(calc.calculateTimeStrain(busyHours: 20).mental == 4)
        #expect(calc.calculateTimeStrain(busyHours: 21).mental == 6)
        #expect(calc.calculateTimeStrain(busyHours: 22).mental == 9)
        #expect(calc.calculateTimeStrain(busyHours: 23).physical == 13)
        #expect(calc.calculateTimeStrain(busyHours: 24).mental == 18)
    }
}
