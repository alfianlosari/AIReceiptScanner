import Foundation

func printDebug(_ log: String) {
    #if DEBUG
    print("XCA AIReceiptScanner: \(log)")
    #endif
}

struct Utils {
    
    static let shared = Utils()
    
    private init() {}
    
    let currentDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    func formatAmount(_ amount: Double, currency: String?) -> String {
        numberFormatter.currencyCode = currency ?? ""
        return numberFormatter.string(from: NSNumber(value: amount)) ?? String(amount)
    }
}
