import Foundation

enum HabitUIState: Equatable {
    case loading
    case emptyList
    case fullList([HabitCardViewModel])
    case error(String)
}
