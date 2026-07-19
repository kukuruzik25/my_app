import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Тока тока тока", count: "380", formatText: "часов осталось", colorHex: "#BA0D61")
    }

    func getSnapshot(in context: Context, completion: SimpleEntry -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Тока тока тока", count: "380", formatText: "часов осталось", colorHex: "#BA0D61")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: Timeline<Entry> -> ()) {
        // Читаем данные, которые Flutter сохранил в App Group
        let sharedDefaults = UserDefaults(suiteName: "group.com.example.myCountdownApp")
        
        let title = sharedDefaults?.string(forKey: "widget_title") ?? "Тока тока тока"
        let count = sharedDefaults?.string(forKey: "widget_count") ?? "380"
        let formatText = sharedDefaults?.string(forKey: "widget_format_text") ?? "часов осталось"
        
        // Получаем HEX-цвет из настроек (по дефолту малиновый #BA0D61)
        let colorHex = sharedDefaults?.string(forKey: "widget_color_hex") ?? "#BA0D61"
        
        let entry = SimpleEntry(date: Date(), title: title, count: count, formatText: formatText, colorHex: colorHex)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let count: String
    let formatText: String
    let colorHex: String
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            // Верхнее название счетчика (светлый оттенок выбранного цвета)
            Text(entry.title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: entry.colorHex).opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            // Главная цифра по центру (акцентный цвет из настроек)
            Text(entry.count)
                .font(.system(size: 54, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: entry.colorHex))
                .lineLimit(1)
            
            // Формат отображения: часов/дней/недель осталось
            Text(entry.formatText)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(hex: entry.colorHex).opacity(0.6))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

@main
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetExtensionEntryView(entry: entry)
                    .containerBackground(.white, for: .widget)
            } else {
                WidgetExtensionEntryView(entry: entry)
                    .padding()
            }
        }
        .configurationDisplayName("Countdown Widget")
        .description("Виджет с поддержкой тем.")
        .supportedFamilies([.systemSmall])
    }
}

// Вспомогательное расширение для чтения HEX-цветов во SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17) & 15, (int >> 4 & 15) * 17, (int & 15) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 255, (int >> 8) & 255, (int & 255) & 255)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 255, (int >> 16) & 255, (int >> 8) & 255, (int & 255) & 255)
        default:
            (a


r, g, b) = (255, 186, 13, 97) // Дефолтный малиновый
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
},


