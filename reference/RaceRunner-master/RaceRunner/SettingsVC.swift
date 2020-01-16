//
//  SettingsVC.swift
//  RaceRunner
//
//  Created by Joshua Adams on 3/1/15.
//  Copyright (c) 2015 Josh Adams. All rights reserved.
//

import UIKit
import DLRadioButton
import StoreKit
import CloudKit
import Intents

class SettingsVC: ChildVC, BroadcastDelegate {
  @IBOutlet var unitsToggle: UISwitch!
  @IBOutlet var iconToggle: UISwitch!
  @IBOutlet var broadcastNextRunButton: UIButton!
  @IBOutlet var multiplierSlider: UISlider!
  @IBOutlet var multiplierLabel: UILabel!
  @IBOutlet var viewControllerTitle: UILabel!
  @IBOutlet var showMenuButton: UIButton!
  @IBOutlet var autoStopToggle: UISwitch!
  @IBOutlet var autoStopButton: UIButton!
  @IBOutlet var splitsToggle: UISwitch!
  @IBOutlet var splitsButton: UIButton!
  @IBOutlet var neverButton: UIButton!
  @IBOutlet var noneButton: UIButton!
  @IBOutlet var audibleSplitsToggle: UISwitch!
  @IBOutlet var accentButtons: [DLRadioButton]!
  @IBOutlet var weightLabel: UILabel!
  @IBOutlet var weightStepper: UIStepper!
  @IBOutlet var showWeightToggle: UISwitch!
  @IBOutlet var buyLabel: UILabel!
  @IBOutlet var runningHorseButton: UIButton!
  @IBOutlet var broadcastRunsButton: UIButton!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var restoreButton: UIButton!
  
  private static let distancePrompt = " To begin inputting, tap \"123\" on the bottom-left corner of your virtual keyboard."
  private static let bummerTitle = "😓"
  private static let noHorseMessage = "RaceRunner cannot display the animated horse during your runs because you have not purchased that feature. If you would like to buy it, tap the Running Horse button in the Buy section below."
  private static let noBroadcastMessage = "RaceRunner cannot broadcast your runs to spectators because you have not bought that feature. If you would like to buy it, tap the Broadcast Runs button in the Buy section below."
  private static let promoCodeTitle = "Input Promo Code"
  private static let promoCodePrompt = "To unlock RaceRunner's in-app purchases, input a promo code and tap Unlock."
  private static let promoCodeUnlock = "Unlock"
  private static let cancel = "Cancel"
  private static let promoCode = "Promo Code"
  private static let sweetTitle = "Sweet"
  private static let unlockedMessage = "In-app purchases unlocked!"
  private static let invalidPromoCodeMessage = "In-app purchases not unlocked. Promo code is invalid."
  private static let unlockErrorMessage = "Could not unlock in-app purchases"
  private static let broadcastNextRunTitle = "Broadcast Next Run"
  private static let stopBroadcastingTitle = "Stop Broadcasting"
  private var products = [SKProduct]()

  @IBAction func showMenu(_ sender: UIButton) {
    showMenu()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateToggles()
    updateSplitsWidgets()
    updateAutoStopWidgets()
    updateMultiplierLabel()
    updateWeightStepper()
    updateWeightLabel()
    for button in accentButtons {
      if (button.titleLabel?.text ?? "") == SettingsManager.getAccent().rawValue {
        button.isSelected = true
        break
      }
    }
    multiplierSlider.value = Float(SettingsManager.getMultiplier())
    viewControllerTitle.attributedText = UiHelpers.letterPressedText(viewControllerTitle.text ?? "")
    NotificationCenter.default.addObserver(self, selector: #selector(SettingsVC.productPurchased), name: NSNotification.Name(rawValue: IapHelperProductPurchasedNotification), object: nil)
    setUpProducts()
    let secretSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SettingsVC.unlockIaps))
    secretSwipeRecognizer.numberOfTouchesRequired = 2
    secretSwipeRecognizer.direction = .left
    view.addGestureRecognizer(secretSwipeRecognizer)
    SettingsManager.setBroadcastNextRun(false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    AWSAnalyticsService.shared.recordVisitation(viewController: "\(SettingsVC.self)")
    updateBroadcastButton()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
    return UnwindPanSegue(identifier: identifier ?? "", source: fromViewController, destination: toViewController, performHandler: { () -> Void in
    })
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "pan publish" {
      (segue.destination as? BroadcastVC)?.broadcastDelegate = self
    }
  }

  @IBAction func returnFromSegueActions(_ sender: UIStoryboardSegue) {}

  @IBAction func toggleUnitType(_ sender: UISwitch) {
    if sender.isOn {
      SettingsManager.setUnitType(.metric)
    } else {
      SettingsManager.setUnitType(.imperial)
    }
    updateSplitsWidgets()
    updateAutoStopWidgets()
    updateWeightStepper()
    updateWeightLabel()
  }

  @IBAction func toggleIconType(_ sender: UISwitch) {
    if sender.isOn && !Products.store.isProductPurchased(Products.runningHorse) {
      UIAlertController.showMessage(SettingsVC.noHorseMessage, title: SettingsVC.bummerTitle)
      sender.isOn = false
    } else {
      if sender.isOn {
        SettingsManager.setIconType(RunnerIcons.IconType.horse)
      } else {
        SettingsManager.setIconType(RunnerIcons.IconType.human)
      }
    }
  }

  @IBAction func toggleAutoStop(_ sender: UISwitch) {
    if sender.isOn {
      setAutoStop()
    } else {
      SettingsManager.setStopAfter(SettingsManager.never)
      updateAutoStopWidgets()
    }
  }

  @IBAction func toggleSplits(_ sender: UISwitch) {
    if sender.isOn {
      setSplits()
    } else {
      SettingsManager.setReportEvery(SettingsManager.never)
    }
    updateSplitsWidgets()
  }

  @IBAction func neverAutoStop() {
    if autoStopToggle.isOn {
      autoStopToggle.isOn = false
      autoStopButton.setTitle("", for: UIControl.State())
      SettingsManager.setStopAfter(SettingsManager.never)
    }
  }

  @IBAction func changeSplits() {
    setSplits()
  }

  @IBAction func changeStopAfter() {
    setAutoStop()
  }

  @IBAction func toggleAudibleSplits(_ sender: UISwitch) {
    if sender.isOn {
      SettingsManager.setAudibleSplits(true)
    } else {
      SettingsManager.setAudibleSplits(false)
    }
  }

  @IBAction func changeAccent(_ sender: DLRadioButton) {
    let selectedFlag = sender.selected()?.titleLabel?.text
    if let selectedFlag = selectedFlag {
      SettingsManager.setAccent(selectedFlag)
    }
  }

  @IBAction func multiplierChanged(_ sender: UISlider) {
    SettingsManager.setMultiplier(round(Double(sender.value)))
    updateMultiplierLabel()
  }

  @IBAction func weightChanged(_ sender: UIStepper) {
    switch SettingsManager.getUnitType() {
    case .imperial:
      SettingsManager.setWeight(sender.value / Converter.poundsPerKilogram)
    case .metric:
      SettingsManager.setWeight(sender.value)
    }
    updateWeightLabel()
  }

  @IBAction func toggleShowWeight(_ sender: UISwitch) {
    if sender.isOn {
      SettingsManager.setShowWeight(true)
    } else {
      SettingsManager.setShowWeight(false)
    }
  }

  @IBAction func buyRunningHorse() {
    if products.count == 2 {
      Products.store.purchaseProduct(products[1])
    }
  }

  @IBAction func buyBroadcastRuns() {
    if products.count == 2 {
      Products.store.purchaseProduct(products[0])
    }
  }

  @IBAction func startOrStopBroadcasting() {
    if !SettingsManager.getBroadcastNextRun() && !Products.store.isProductPurchased(Products.broadcastRuns) {
      UIAlertController.showMessage(SettingsVC.noBroadcastMessage, title: SettingsVC.bummerTitle)
      return
    }
    if !SettingsManager.getBroadcastNextRun() {
      performSegue(withIdentifier: "pan publish", sender: self)
    } else {
      SettingsManager.setBroadcastNextRun(false)
      updateBroadcastButton()
      PubNubManager.runStopped()
    }
  }

  @IBAction func restorePurchases(_ sender: UIButton) {
    Products.store.restoreCompletedTransactions()
  }

  func updateBroadcastButton() {
    broadcastNextRunButton.setTitle(SettingsManager.getBroadcastNextRun() ? SettingsVC.stopBroadcastingTitle : SettingsVC.broadcastNextRunTitle, for: UIControl.State())
  }
  
  @objc func unlockIaps() {
    let purchasedHorse = Products.store.isProductPurchased(Products.runningHorse)
    let purchasedBroadcast = Products.store.isProductPurchased(Products.broadcastRuns)
    if !purchasedBroadcast || !purchasedHorse {
      let alertController = UIAlertController(title: SettingsVC.promoCodeTitle, message: SettingsVC.promoCodePrompt, preferredStyle: UIAlertController.Style.alert)
      let unlockAction = UIAlertAction(title: SettingsVC.promoCodeUnlock, style: UIAlertAction.Style.default, handler: { action in
        let textFields = alertController.textFields ?? []
        let predicate = NSPredicate(format: "promoCode = %@", textFields[0].text?.lowercased() ?? "🙀")
        let query = CKQuery(recordType: "PromoCodes", predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) {
          results, error in
          if error == nil {
            if let results = results, !results.isEmpty {
              DispatchQueue.main.async {
                UIAlertController.showMessage(SettingsVC.unlockedMessage, title: SettingsVC.sweetTitle)
                Products.store.fakeIapPurchases()
              }
            } else {
              DispatchQueue.main.async {
                UIAlertController.showMessage(SettingsVC.invalidPromoCodeMessage, title: SettingsVC.bummerTitle)
              }
            }
          } else {
            DispatchQueue.main.async {
              let errorMessage = error?.localizedDescription ?? ""
              UIAlertController.showMessage("\(SettingsVC.unlockErrorMessage): \(errorMessage)", title: SettingsVC.bummerTitle)
            }
          }
        }
      })
      alertController.addAction(unlockAction)
      let cancelAction = UIAlertAction(title: SettingsVC.cancel, style: UIAlertAction.Style.cancel, handler: { action in })
      alertController.addAction(cancelAction)
      alertController.addTextField { textField in
        textField.placeholder = SettingsVC.promoCode
      }
      alertController.view.tintColor = UiConstants.intermediate1Color
      present(alertController, animated: true, completion: nil)
    }
  }
  
  func setUpProducts() {
    products = []
    Products.store.requestProductsWithCompletionHandler { success, products in
      if success {
        self.products = products
      } else {
        print("Failed to retrieve IAP products.")
      }
    }
    updatePurchaseWidgets()
  }
  
  func updatePurchaseWidgets() {
    let purchasedHorse = Products.store.isProductPurchased(Products.runningHorse)
    let purchasedBroadcast = Products.store.isProductPurchased(Products.broadcastRuns)
    if purchasedHorse && purchasedBroadcast {
      buyLabel.isHidden = true
      runningHorseButton.isHidden = true
      broadcastRunsButton.isHidden = true
      priceLabel.isHidden = true
      restoreButton.isHidden = true
    } else if purchasedHorse && !purchasedBroadcast{
      buyLabel.isHidden = false
      runningHorseButton.isHidden = true
      broadcastRunsButton.isHidden = false
      priceLabel.isHidden = false
      restoreButton.isHidden = false
    } else if !purchasedHorse && purchasedBroadcast{
      buyLabel.isHidden = false
      runningHorseButton.isHidden = false
      broadcastRunsButton.isHidden = true
      priceLabel.isHidden = false
      restoreButton.isHidden = false
    } else { // purchased neither
      buyLabel.isHidden = false
      runningHorseButton.isHidden = false
      broadcastRunsButton.isHidden = false
      priceLabel.isHidden = false
      restoreButton.isHidden = false
    }
  }
  
  @objc func productPurchased(_ notification: Notification) {
//    let productIdentifier = notification.object as! String
//    for (index, product) in products.enumerate() {
//      if product.productIdentifier == productIdentifier {
//        print("purchased: \(productIdentifier)  index: \(index)")
//        break
//      }
//    }
    updatePurchaseWidgets()
  }
  
  func updateToggles() {
    if SettingsManager.getUnitType() == .imperial {
      unitsToggle.isOn = false
    } else {
      unitsToggle.isOn = true
    }
    if SettingsManager.getIconType() == RunnerIcons.IconType.human {
      iconToggle.isOn = false
    } else {
      iconToggle.isOn = true
    }
    showWeightToggle.isOn = SettingsManager.getShowWeight()
    audibleSplitsToggle.isOn = SettingsManager.getAudibleSplits()
  }
  
  func updateWeightStepper() {
    switch SettingsManager.getUnitType() {
    case .imperial:
      weightStepper.maximumValue = HumanWeight.maxImperial
      weightStepper.minimumValue = HumanWeight.minImperial
      weightStepper.value = SettingsManager.getWeight() * Converter.poundsPerKilogram
    case .metric:
      weightStepper.maximumValue = HumanWeight.maxMetric
      weightStepper.minimumValue = HumanWeight.minMetric
      weightStepper.value = SettingsManager.getWeight()
    }
  }
  
  func updateWeightLabel() {
    weightLabel.text = "Weight: " + HumanWeight.weightAsString()
  }
  
  func updateDistanceWidgets(_ interval: Double, button: UIButton, toggle: UISwitch, prefix: String) {
    let buttonTitle: String
    if interval == SettingsManager.never {
      toggle.isOn = false
      buttonTitle = ""
    } else {
      toggle.isOn = true
      if interval < 1.0 {
        buttonTitle = String(format: "%@ %.2f %@", prefix, interval, Converter.getCurrentAbbreviatedLongUnitName())
      } else if interval == 1.0 {
        buttonTitle = "\(prefix) 1 \(Converter.getCurrentAbbreviatedLongUnitName())"
      } else if interval > 1.0 && interval < 100.00 {
        buttonTitle = String(format: "%@ %.2f %@", prefix, interval, Converter.getCurrentPluralLongUnitName())
      } else { // interval >= 100
        buttonTitle = String(format: "%@ %.1f %@", prefix, interval, Converter.getCurrentPluralLongUnitName())
      }
    }
    button.setTitle(buttonTitle, for: UIControl.State())
  }
  
  func updateSplitsWidgets() {
    updateDistanceWidgets(Converter.convertMetersToLongDistance(SettingsManager.getReportEvery()), button: splitsButton, toggle: splitsToggle, prefix: "Every")
  }

  func updateAutoStopWidgets() {
    updateDistanceWidgets(Converter.convertMetersToLongDistance(SettingsManager.getStopAfter()), button: autoStopButton, toggle: autoStopToggle, prefix: "After")
  }

  func setAutoStop() {
    getDistanceInterval("How many \(Converter.getCurrentPluralLongUnitName()) would you like to stop the run after?")
    { newValue in
      SettingsManager.setStopAfter(Converter.convertLongDistanceToMeters(newValue))
      self.updateAutoStopWidgets()
    }
  }
  
  @IBAction func dontReportSplits() {
    if splitsToggle.isOn {
      splitsToggle.isOn = false
      splitsButton.setTitle("", for: UIControl.State())
      SettingsManager.setReportEvery(SettingsManager.never)
    }
  }

  func setSplits() {
    getDistanceInterval("How far in \(Converter.getCurrentPluralLongUnitName()) would you like to run between audible reports of your progress?")
    { newValue in
      SettingsManager.setReportEvery(Converter.convertLongDistanceToMeters(newValue))
      self.updateSplitsWidgets()
    }
  }
  
  func getDistanceInterval(_ prompt: String, invalidValue: Bool? = nil, closure: @escaping (Double) -> Void) {
    var fullPrompt = prompt
    if invalidValue != nil && invalidValue == true {
      fullPrompt = "That is an invalid value. " + fullPrompt
    }
    let alertController = UIAlertController(title: "👟", message: fullPrompt + SettingsVC.distancePrompt, preferredStyle: UIAlertController.Style.alert)
    alertController.view.tintColor = UiConstants.darkColor
    let setAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: { action in
      let textFields = alertController.textFields ?? []
      if let text = textFields[0].text, let numericValue = Double(text) , numericValue >= SettingsManager.minStopAfter && numericValue <= SettingsManager.maxStopAfter {
          closure(numericValue)
      } else {
          self.getDistanceInterval(prompt, invalidValue: true, closure: closure)
      }
    })
    alertController.addAction(setAction)
    alertController.addTextField { textField in
      textField.placeholder = "Distance"
      textField.keyboardType = UIKeyboardType.default
    }
    present(alertController, animated: true, completion: nil)
  }

  func updateMultiplierLabel() {
    multiplierLabel.text = String(format: "%.0f%%", SettingsManager.getMultiplier() * 100.0)
  }

  func userWantsToBroadcast(_ userWantsToBroadcast: Bool) {
    SettingsManager.setBroadcastNextRun(userWantsToBroadcast)
    updateBroadcastButton()
  }
}
