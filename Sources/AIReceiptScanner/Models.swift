//
//  Models.swift
//  AIExpenseTracker
//
//  Created by Alfian Losari on 22/06/24.
//

import Foundation

public struct Receipt: Codable, Identifiable, Equatable {
    public let id = UUID()
    
    public var receiptId: String?
    public var date: Date?
    public var tax: Double?
    public var discount: Double?
    public var total: Double?
    public var paymentMethod: String?
    public var currency: String?
    public var merchantName: String?
    public var customerName: String?
    public var items: [LineItem]?
    
    public init(receiptId: String? = nil, date: Date? = nil, tax: Double? = nil, discount: Double? = nil, total: Double? = nil, paymentMethod: String? = nil, currency: String? = nil, merchantName: String? = nil, customerName: String? = nil, items: [LineItem]? = nil) {
        self.receiptId = receiptId
        self.date = date
        self.tax = tax
        self.discount = discount
        self.total = total
        self.paymentMethod = paymentMethod
        self.currency = currency
        self.merchantName = merchantName
        self.customerName = customerName
        self.items = items
    }
}

public struct LineItem: Codable, Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let price: Double
    public let category: String
    public let quantity: Double
    
    public init(name: String, price: Double, category: String, quantity: Double) {
        self.name = name
        self.price = price
        self.category = category
        self.quantity = quantity
    }
}

enum Category: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case accountingAndLegalFees = "Accounting and legal fees"
    case bankFees = "Bank fees"
    case consultantsAndProfessionalServices = "Consultants and professional services"
    case depreciation = "Depreciation"
    case employeeBenefits = "Employee benefits"
    case employeeExpenses = "Employee expenses"
    case entertainment = "Entertainment"
    case food = "Food"
    case gifts = "Gifts"
    case health = "Health"
    case insurance = "Insurance"
    case interest = "Interest"
    case learning = "Learning"
    case licensingFees = "Licensing fees"
    case marketing = "Marketing"
    case membershipFees = "Membership fees"
    case officeSupplies = "Office supplies"
    case payroll = "Payroll"
    case repairs = "Repairs"
    case rent = "Rent"
    case rentOrMortgagePayments = "Rent or mortgage payments"
    case software = "Software"
    case tax = "Tax"
    case travel = "Travel"
    case utilities = "Utilities"
}
