/// A calendar date in the Vesprium system, stored as days since the epoch day.
///
/// Epoch: **year 1, month 1 (``VespriumMonth/thaw``), day 1** has ``daysSinceEpoch`` == 0.
public struct VespriumDate: Codable, Sendable, Equatable, Hashable, Comparable {
    /// Days from the epoch (first day of year 1); may be negative.
    public var daysSinceEpoch: Int

    public init(daysSinceEpoch: Int) {
        self.daysSinceEpoch = daysSinceEpoch
    }

    /// Creates a date from year, month, and day-of-month (1…28). Returns `nil` if components are invalid.
    public init?(year: Int, month: VespriumMonth, day: Int) {
        guard day >= 1, day <= VespriumCalendar.daysPerMonth else { return nil }
        let y = year - 1
        let d = y * VespriumCalendar.daysPerYear
            + (month.rawValue - 1) * VespriumCalendar.daysPerMonth
            + (day - 1)
        self.daysSinceEpoch = d
    }

    public var year: Int {
        Self.divFloor(daysSinceEpoch, VespriumCalendar.daysPerYear) + 1
    }

    public var month: VespriumMonth {
        let dayOfYear = Self.modFloor(daysSinceEpoch, VespriumCalendar.daysPerYear)
        let ordinal = dayOfYear / VespriumCalendar.daysPerMonth + 1
        return VespriumMonth(rawValue: ordinal)!
    }

    public var day: Int {
        let dayOfYear = Self.modFloor(daysSinceEpoch, VespriumCalendar.daysPerYear)
        return dayOfYear % VespriumCalendar.daysPerMonth + 1
    }

    public func adding(days: Int) -> VespriumDate {
        VespriumDate(daysSinceEpoch: daysSinceEpoch + days)
    }

    public func adding(years: Int) -> VespriumDate {
        adding(days: years * VespriumCalendar.daysPerYear)
    }

    public func adding(months: Int) -> VespriumDate {
        adding(days: months * VespriumCalendar.daysPerMonth)
    }

    public func daysSince(_ other: VespriumDate) -> Int {
        daysSinceEpoch - other.daysSinceEpoch
    }

    /// Weekday for this date, given which weekday the epoch day (Y1 M1 D1) falls on.
    public func weekday(assumingEpochDayIs epochWeekday: Weekday) -> Weekday {
        let index = Self.modFloor(daysSinceEpoch + epochWeekday.rawValue, VespriumCalendar.daysPerWeek)
        return Weekday(rawValue: index)!
    }

    public static func < (lhs: VespriumDate, rhs: VespriumDate) -> Bool {
        lhs.daysSinceEpoch < rhs.daysSinceEpoch
    }

    private static func divFloor(_ a: Int, _ b: Int) -> Int {
        assert(b > 0)
        if a >= 0 { return a / b }
        return -((-a + b - 1) / b)
    }

    private static func modFloor(_ a: Int, _ b: Int) -> Int {
        assert(b > 0)
        let r = a % b
        return r >= 0 ? r : r + b
    }
}
