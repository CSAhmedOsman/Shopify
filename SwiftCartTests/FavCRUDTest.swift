//
//  FavCRUDTest.swift
//  SwiftCartTests
//
//  Created by Anas Salah on 23/06/2024.
//

import XCTest
import Alamofire
@testable import SwiftCart

final class FavCRUDTest: XCTestCase {

    var favCRUD: FavCRUD!

    override func setUpWithError() throws {
        favCRUD = FavCRUD()
    }

    override func tearDownWithError() throws {
        favCRUD = nil
    }

    func testGetDraftOrderNetworkCallWithValidID() {
        let expectation = self.expectation(description: "Waiting for getDraftOrder API response")
        
        let favId = 967662698543
        
        favCRUD.getDraftOrder(favId: favId) { draftOrder in
            XCTAssertNotNil(draftOrder, "Draft order should not be nil")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGetDraftOrderNetworkCallWithUnValidID() {
        let expectation = self.expectation(description: "Waiting for getDraftOrder API response")
        
        let favId = 123456
        
        favCRUD.getDraftOrder(favId: favId) { draftOrder in
            XCTAssertNil(draftOrder, "Draft order should be nil")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testDeleteItemFromDraftOrder() {
        let expectation = self.expectation(description: "Waiting for deleteItem API response")
        
        
        let favId = 967662698543
        let itemIdToDelete = 123456 // simulate an id is not exist in fav
        
        favCRUD.deleteItem(favId: favId, itemId: itemIdToDelete)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.favCRUD.getDraftOrder(favId: favId) { draftOrder in
                if let draftOrder = draftOrder {
                    let itemExists = draftOrder.line_items?.contains(where: {
                        $0.properties.contains(where: { $0["name"] == "itemId" && $0["value"] == String(itemIdToDelete) })
                    })
                    XCTAssertFalse(itemExists ?? true, "Item should not exist in draft order after deletion")
                } else {
                    XCTFail("Failed to fetch draft order after deletion")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

}
