//
//  ReceiptScanner.swift
//  AIReceiptScanner
//
//  Created by Alfian Losari on 29/06/24.
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif
import ChatGPTSwift
import Foundation

public struct AIReceiptScanner {
    
    let api: ChatGPTAPI
    let systemText: String
    let promptText: String =
"""
Carefully analyze this receipt image and extract ALL items with their exact quantities and prices. Follow these instructions precisely:

IMPORTANT RULES:
1. Extract EVERY item shown on the receipt - do not skip any items
2. Look for quantity indicators like "2 x", "QTY 2", numbers before item names, or weight (kg/lb)
3. For weighted items (e.g., "2.00 e/kg"), the first number is the quantity in kg
4. Match the exact total amount shown on the receipt

Use this exact JSON format:
{
    "receiptId": "receipt id or no. don't return if not exists. string type",
    "merchantName": "name of merchant. don't return if not exits. string type",
    "customerName": "name of customer. don't return if not exits. string type",
    "date": "date of the receipt. always use this string format as the response yyyy-MM-dd. If no year is provided, just use current year",
    "tax": "tax of receipt. don't return if not exists. number type",
    "discount: "savings or discount. don't return if not exists. number type",
    "total": "total amount paid of receipt. number type",
    "paymentMethod: "enum of cash, creditCard, debitCard, eMoney. use cash as default value if not exists. string type",
    "currency": "currency of the receipt, always use 3 digit country code format"
    "items": [
        {
            "name": "exact name of the item as shown. string type",
            "price": "unit price or line total (check receipt format). number type",
            "quantity": "exact quantity purchased (look for multipliers, weights, or quantity indicators). number type"
            "category": "enum of \(Category.allCases.map {$0.rawValue}.split(separator: ",")). if not sure, use Utilities as fallback value"
        }
    ]
}

Double-check: The sum of all items should approximately match the subtotal/total on the receipt.
"""
    
    let dateFormatterJSONDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom{ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date") }
            return date
        }
        return jsonDecoder
    }()
    
    public init(apiKey: String, systemText: String = "You're master of analyzing transactions/expenses in image receipt") {
        self.api = .init(apiKey: apiKey)
        self.systemText = systemText
    }
    
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    public func scanImage(_ image: ReceiptImage, targetSize: CGSize = .init(width: 1024, height: 1024), compressionQuality: CGFloat = 0.8, model: ChatGPTModel = .gpt_hyphen_4_period_1_hyphen_mini, temperature: Double = 1.0) async throws -> Receipt {
        let imageData: Data
        #if os(macOS)
        imageData = image.scaleToFit(targetSize: targetSize)!.scaledJPGData(compressionQuality: compressionQuality)!
        #else
        imageData = image.scaleToFit(targetSize: targetSize).scaledJPGData(compressionQuality: compressionQuality)
        #endif
        return try await scanImageData(imageData, model: model, temperature: temperature)
    }
    #endif
    
    public func scanImageData(_ data: Data, model: ChatGPTModel = .gpt_hyphen_4_period_1_hyphen_mini, temperature: Double = 1.0) async throws -> Receipt {
        do {
            let response = try await api.sendMessage(
                text: promptText,
                model: model,
                systemText: systemText,
                temperature: temperature,
                responseFormat: .init(_type: .json_object),
                imageData: data)
            let jsonString = response
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "  ", with: "")
                .replacingOccurrences(of: "    ", with: "")
            guard let data = jsonString.data(using: .utf8) else {
                throw "Invalid Data"
            }
            printDebug(response)
            let receipt = try dateFormatterJSONDecoder.decode(Receipt.self, from: data)
            return receipt
        } catch {
            printDebug(error.localizedDescription)
            throw error
        }
    }

}
