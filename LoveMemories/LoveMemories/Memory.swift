import Foundation
import SwiftUI

enum MemoryCategory: String, Codable, CaseIterable {
    case love = "Kalp"
    case travel = "Seyahat"
    case birthday = "Doğum Günü"
    case special = "Özel Gün"
    case other = "Diğer"
    
    var iconName: String {
        switch self {
        case .love: return "heart.fill"
        case .travel: return "airplane"
        case .birthday: return "gift.fill"
        case .special: return "star.fill"
        case .other: return "photo.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .love: return .red
        case .travel: return .orange
        case .birthday: return .purple
        case .special: return Color(red: 1.0, green: 0.4, blue: 0.7) // Pembe
        case .other: return .blue
        }
    }
}

struct Memory: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var imagePath: String?
    var date: Date
    var category: MemoryCategory
}

