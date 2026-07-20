import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Тока тока тока", days: "16")
    }

    func getSnapshot(in context: Context, completion: SimpleEntry -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Тока тока тока", days: "16")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: Timeline<Entry> -> ()) {
        // Здесь home-widget будет передавать реальные данные из Flutter.
        // Если данных пока нет, отобразятся дефолтные из UserDefaults.
        let sharedDefaults = UserDefaults(suiteName: "group.com.example.myCountdownApp")
        let title = sharedDefaults?.string(forKey: "widget_title") ?? "Тока тока тока"
        let days = sharedDefaults?.string(forKey: "widget_days") ?? "16"
        
        let entry = SimpleEntry(date: Date(), title: title, days: days)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let days: String
}

// РЕДАКТИРУЕМ ТУТ: Красивый дизайн как на скриншоте
struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 12) {
            // Верхний розовый текст
            Text(entry.title)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.92, green: 0.51, blue: 0.62)) // Нежно-розовый
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            // Большая малиновая цифра по центру
            Text(entry.days)
                .font(.system(size: 58, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.73, green: 0.05, blue: 0.38)) // Малиновый
                .lineLimit(1)
            
            // Нижний текст
            Text("дней осталось")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.92, green: 0.51, blue: 0.62)) // Нежно-розовый
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Делаем белый фон у самого виджета
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
                    .containerBackground(.white, for: .widget) // Для iOS 17+ фиксируем белый фон
            } else {
                WidgetExtensionEntryView(entry: entry)
            }
        }
        .configurationDisplayName("My Countdown Widget")
        .description("Красивый виджет обратного отсчета.")
        .supportedFamilies([.systemSmall]) // Делаем его маленьким квадратным (1х1)
    }
}
