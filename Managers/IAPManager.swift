//
//  IAPManager.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/18/23.
//

import Foundation
import StoreKit
final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    private var products = [SKProduct]()
    
    private var productBeingPurchased: SKProduct?
    
    static let shared = IAPManager()
    
    private var completion: ((Any?,Bool,Error?) -> Void)?
    enum Product: String, CaseIterable
    {
        case promoteEvent = "MedullaLogic.WhatsPoppin.eventpromotion"
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products returned: \(response.products.count)")
//        self.products = response.products
        products = response.products
        guard let product = products.first else {
            return
        }
        print(product.productIdentifier)
        print(product.price)
        print(product.localizedTitle)
        print(product.localizedDescription)
        
//        purchase(product: product)
    }
    
    public func fetchProduct()
    {
//        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        let request = SKProductsRequest(productIdentifiers: ["MedullaLogic.WhatsPoppin.eventpromotion"])
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard request is SKProductsRequest else {
            return
        }
        print("Product fetch request failed")
    }
    
    public func purchase(product: Product, completion: @escaping((Any?,Bool,Error?)->Void))
    {
        
        guard SKPaymentQueue.canMakePayments()else {
            return
        }
//        productBeingPurchased = product
        guard let storeKitProduct = products.first(where: {$0.productIdentifier == product.rawValue }) else {return}
        self.completion = completion
        let payment = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            transaction in
            
//            guard transaction.payment.productIdentifier == self.productBeingPurchased?.productIdentifier else {
//                continue
//            }
            
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing \(transaction.payment.productIdentifier)...")
                break
            case .purchased:
                handlePurchase(transaction.payment.productIdentifier, error: nil, execute: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .restored:
                fallthrough
            case .failed:
                
                handlePurchase(transaction.payment.productIdentifier, error: transaction.error, execute: false)
                print("Error making purchase \(transaction.error)")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .deferred:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            @unknown default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        })
    }
    
    private func handlePurchase(_ id: String, error: Error?, execute: Bool)
    {
        if(execute)
        {
            if(error == nil)
            {
                if(Product.promoteEvent.rawValue == id)
                {
                    completion?(nil,true, nil)
                }
                
                
                
                
            }
            
        }
        else
        {
            
            if error != nil
            {
                completion?(nil,false, error)
            }
        }
        
        
    }
}
