//
//  ShopifyAPIHelperTest.swift
//  SwiftCartTests
//
//  Created by Anas Salah on 22/06/2024.
//

import XCTest
@testable import SwiftCart
import Alamofire

final class ShopifyAPIHelperTest: XCTestCase {
    
    override func setUpWithError() throws { // TODO: this will run before all tests func.
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws { // TODO: this will run after all tests func.
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        //self.measure {
        //    // Put the code you want to measure the time of here.
        //}
    }
    
    
        func testCreateingCustomer() {
            let expectation = self.expectation(description: "Waiting for create customer API response")
                    // TODO: have to change email with every run to pass this test
            ShopifyAPIHelper.shared.createCustomer(email: "test12@gmail.com", firstName: "anas", lastName: "salah") { result in
                switch result {
                case .success(let successMessage):
                    print(successMessage)
                    XCTAssert(successMessage.contains("Customer created with ID"), "Customer creation should return a success message with ID")
                case .failure(let error):
                    XCTFail("Error creating customer: \(error.localizedDescription)")
                }
    
                expectation.fulfill()
            }
    
            waitForExpectations(timeout: 20, handler: nil)
        }
    
    func testCreateingDraftOrder() {
        let expectation = self.expectation(description: "Waiting for create draft order API response")
        
        ShopifyAPIHelper.shared.createCustomer(email: "12test@gmail.com", firstName: "anas", lastName: "salah") { customerResult in
            switch customerResult {
            case .success(let successMessage):
                guard let customerId = successMessage.split(separator: " ").last else {
                    XCTFail("Customer ID not found in success message")
                    print(successMessage)
                    expectation.fulfill()
                    return
                }
                
                let lineItems: [[String: Any]] = [
                    [
                        "title": "Test Product",
                        "price": "10.00",
                        "quantity": 1
                    ]
                ]
                
                ShopifyAPIHelper.shared.createDraftOrder(customerId: String(customerId), lineItems: lineItems) { draftOrderResult in
                    switch draftOrderResult {
                    case .success(let draftOrderId):
                        print("Draft order created with ID: \(draftOrderId)")
                        XCTAssert(draftOrderId > 0, "Draft order ID should be greater than 0")
                    case .failure(let error):
                        if let afError = error.asAFError {
                            switch afError {
                            case .responseValidationFailed(let reason):
                                print("Response validation failed: \(reason)")
                            case .responseSerializationFailed(let reason):
                                print("Response serialization failed: \(reason)")
                            default:
                                print("Other AFError: \(afError.localizedDescription)")
                            }
                        } else {
                            print("General Error: \(error.localizedDescription)")
                        }
                        
                        if let statusCode = (error as? AFError)?.responseCode, statusCode == 422 {
                            print("Handle specific validation error for status code 422")
                        }
                        
                        XCTFail("Error creating draft order: \(error.localizedDescription)")
                    }
                    
                    expectation.fulfill()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                if let afError = error.asAFError {
                    switch afError {
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(reason)")
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(reason)")
                    default:
                        print("Other AFError: \(afError.localizedDescription)")
                    }
                } else {
                    print("General Error: \(error.localizedDescription)")
                }
                
                if let statusCode = (error as? AFError)?.responseCode, statusCode == 422 {
                    print("Handle specific validation error for status code 422")
                }
                XCTFail("Error creating draft order: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testFaildToCreateRedundentDraftOrder() {
        
        let expectation = self.expectation(description: "Waiting for create draft order API response")
        
        
        ShopifyAPIHelper.shared.createDraftOrder(customerId: String(7106376597551), lineItems: []) { draftOrderResult in
            switch draftOrderResult {
            case .success(let draftOrderId):
                print("Draft order created with ID: \(draftOrderId)")
                XCTFail("Error creating draft redundent order: \(draftOrderId)")
            case .failure(let error):
                print("In failure")
                print(error.localizedDescription)
                if let statusCode = (error as? AFError)?.responseCode {
                    print("Handle specific validation error for status code \(statusCode)")
                    
                    XCTAssertEqual(statusCode, 422)
                    expectation.fulfill()
                }
            }
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }
}
    
