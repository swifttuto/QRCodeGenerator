//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by Yannick LORIOT on 23/02/16.
//  Copyright © 2016 Swift Tuto. All rights reserved.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var qrcodeTextField: UITextField!
  @IBOutlet weak var qrcodeImageView: UIImageView!

  var qrcodeImage: CIImage? {
    didSet {
      if let image = qrcodeImage {
        let scaleX = qrcodeImageView.bounds.width / image.extent.width
        let scaleY = qrcodeImageView.bounds.height / image.extent.height

        let transformedImage = image.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))

        qrcodeImageView.image = UIImage(CIImage: transformedImage)
      }
      else {
        qrcodeImageView.image = nil
      }
    }
  }

  // MARK: - Updating the QRCode

  func updateQRCodeImageWithText(text: String) {
    if let data = text.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false), let filter = CIFilter(name: "CIQRCodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue("Q", forKey: "inputCorrectionLevel")

      qrcodeImage = filter.outputImage
    }
  }

  // MARK: - UITextField Delegate Methods

  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      let newText = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)

      updateQRCodeImageWithText(newText)
    }

    return true
  }
}

