//
//  ShippingViewController.swift
//  SwiftCart
//
//  Created by Israa on 22/06/2024.
//

import UIKit
import RxSwift
import RxCocoa
import PassKit


class ShippingViewController: UIViewController {
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var grandTotalPrice: UILabel!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var promocodeTextField: UITextField!
    var coordinator: SettingsCoordinator?
    var selectedAddress: Address?
    var viewModel = ShippingViewModel(network: NetworkManager.shared)
    var orderViewModel = OrderViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressTextField.delegate = self
        viewModel.getCartProductsList()
    
        viewModel.bindShipping = { [weak self] in
            DispatchQueue.main.async {
                self?.grandTotalPrice.text = self?.viewModel.GrandPrice.formatAsCurrency()
            }
        }
    }
    
    @IBAction func applyPromocode(_ sender: Any) {
        guard let promocode = promocodeTextField.text, !promocode.isEmpty else {
            Utils.showAlert(title: "Invalid Promo Code", message: "Please enter a valid promo code.", preferredStyle: .alert, from: self)
            return
        }
        
        viewModel.getPriceRuleDetails(promocode: promocode)
        self.setPrice(viewModel.draftOrder!)
    }
    func createPaymentRequest() -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = K.Shopify.MERCHANT_ID
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = .threeDSecure
        request.countryCode = "US"
        request.currencyCode = UserDefaultsHelper.shared.getCurrencyType() ?? "USD"
        request.paymentSummaryItems =  createItemsSummary()
        return request
    }
    
    func setPrice(_ order: DraftOrderResponseModel) {
        if let discount = order.singleResult?.appliedDiscount {
            let type: String
            var totalPrice: Double
            let discountValue = Double(discount.value)!
            
            if discount.valueType == "fixed_amount" {
                type = ""
                totalPrice = Double(order.singleResult?.totalPrice ?? "0")! - discountValue
                if totalPrice < 0 { totalPrice = 0 }
                
            } else {
                type = "%"
                let discountAmount = (discountValue / 100) * Double(order.singleResult?.subtotalPrice ?? "0")!
                totalPrice = Double(order.singleResult?.subtotalPrice ?? "0")! - discountAmount
                if totalPrice < 0 { totalPrice = 0 }
            }
            
            DispatchQueue.main.async {
                      self.grandTotalPrice.text = String(totalPrice).formatAsCurrency()
                      self.discountPercentage.text = "\(discountValue) \(type)"
                self.applyBtn.isEnabled = false
                self.promocodeTextField.isEnabled = false
                self.promocodeTextField.textColor = .gray
                self.applyBtn.setTitle("Verified", for: .normal)
                  }
        }
    }
    func createItemsSummary() -> [PKPaymentSummaryItem] {
        guard let draftOrder = viewModel.draftOrder?.singleResult else {
            return []
        }
        
        var itemsSummary: [PKPaymentSummaryItem] = []
        for item in draftOrder.lineItems {
            let amountValue = String((Double(item.productPrice)! * Double(item.quantity)))
            itemsSummary.append(
                PKPaymentSummaryItem(
                    label: "\(item.productTitle) x\(item.quantity)",
                    amount: NSDecimalNumber(string: String(amountValue.formatAsCurrency()))
                )
            )
        }
        
        itemsSummary.append(
            PKPaymentSummaryItem(
                label: "Total",
                amount: NSDecimalNumber(string: grandTotalPrice.text)
            )
        )
        
        return itemsSummary
    }

    
    
    @IBAction func cashOnDelivery(_ sender: Any) {
        if checkAddressSelected() {
            let totalPrice = Double(viewModel.GrandPrice)!
            if  totalPrice > K.Shopify.CART_LIMIT_PRICE {
                noCashOnDeliveryAvailable()
            }else{
                createAndAddOrder()
                viewModel.deleteLineItems()
                coordinator?.finish()
            }
        }
    }
    
    @IBAction func applePay(_ sender: Any) {
        if checkAddressSelected() {
            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: createPaymentRequest()) {
               
                paymentVC.delegate = self
                present(paymentVC, animated: true, completion: nil)
            }
            else {
                print("Unable to present Apple Pay authorization.")
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
   private func checkAddressSelected() -> Bool {
        if AddressTextField.text?.isEmpty == true {
            Utils.showAlert(title: "Shipping Address", message: "Please, select address before continue!", preferredStyle: .alert, from: self)
            return false
        }
        return true
    }
    
    private func noCashOnDeliveryAvailable() {
        Utils.showAlert(title: "Reached Price Limit", message: "Cash on delivery is not allowed on orders of total price higher than \(String (K.Shopify.CART_LIMIT_PRICE).formatAsCurrency()). Use Apple Pay instead.", preferredStyle: .alert, from: self)
    }
    
    private func createAndAddOrder() {
        guard let selectedAddress = selectedAddress else { return }
        let prouductNum = viewModel.draftOrder?.singleResult?.lineItems.count ?? 1
        let newOrder = Order(
            id: nil,
            orderNumber: viewModel.draftOrder?.singleResult?.id,
            productNumber: "\(String(describing: (prouductNum-1)))",
            address: selectedAddress,
            date: getCurrentDateString(),
            currency: UserDefaultsHelper.shared.getCurrencyType() ?? "USD",
            email: UserDefaults.standard.string(forKey: "userEmail") ?? "",
            totalPrice: viewModel.GrandPrice ?? "0.0",
            items: viewModel.draftOrder?.singleResult?.lineItems.dropFirst().map { lineItem in
                let imageUrl: String? = {
                    if !lineItem.properties.isEmpty, lineItem.properties[0].name == "image" {
                        return lineItem.properties[0].value
                    }
                    return nil
                }()

                return ItemProductOrder(
                    id: lineItem.id,
                    image: imageUrl,
                    price: lineItem.productPrice,
                    quantity: lineItem.quantity,
                    title: lineItem.productTitle
                )
            } ?? [],
            userID: Int(K.Shopify.userID),
            billingAddress: selectedAddress,
            customer: UserDefaultsHelper.shared.printUserDefaults()
        )

        orderViewModel.addNewOrder(newOrder: newOrder)
    }

    
    func getCurrentDateString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
}

extension ShippingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == AddressTextField) {
            coordinator?.goToAddresses(mode: .select(delegate: self))
            return false
        }
        return true
    }
}
extension ShippingViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        createAndAddOrder()
        // place order --> Elham Entry Point
        
        viewModel.deleteLineItems()
    }
    
    
}
extension ShippingViewController: AddressSelectionDelegate {
    func didSelectAddress(_ address: Address) {
        selectedAddress = address
        AddressTextField.text = "\(address.address1!) - \(address.city!) \\ Egypt"
    }
}

protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(_ address: Address)
}

