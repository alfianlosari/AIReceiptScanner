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
Tell me the detail and items in this image receipt. Don't put discount, subtotal, and total, and tax inside items array. Use this JSON format as the response.
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
            "name": "name of the item. string type",
            "price": "price of the transaction. number type",
            "quantity": "quantity of item purchased . number type"
        }
    ]
}
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
    public func scanImage(_ image: ReceiptImage, targetSize: CGSize = .init(width: 512, height: 512), compressionQuality: CGFloat = 0.5, model: ChatGPTModel = .gpt_hyphen_3_period_5_hyphen_turbo, temperature: Double = 1.0) async throws -> Receipt {
        let imageData: Data
        #if os(macOS)
        imageData = image.scaleToFit(targetSize: targetSize)!.scaledJPGData(compressionQuality: compressionQuality)!
        #else
        imageData = image.scaleToFit(targetSize: targetSize).scaledJPGData(compressionQuality: compressionQuality)
        #endif
        return try await scanImageData(imageData, model: model, temperature: temperature)
    }
    #endif
    
    public func scanImageData(_ data: Data, model: ChatGPTModel = .gpt_hyphen_4o, temperature: Double = 1.0) async throws -> Receipt {
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
