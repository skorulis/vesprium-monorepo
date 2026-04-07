/// Vesprium game calendar: fixed-length months and a ten-month year.
public enum VespriumCalendar: Sendable {
    public static let daysPerWeek = 7
    public static let weeksPerMonth = 4
    public static let daysPerMonth = daysPerWeek * weeksPerMonth
    public static let monthsPerYear = 10
    public static let daysPerYear = daysPerMonth * monthsPerYear
}
