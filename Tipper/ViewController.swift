//
//  ViewController.swift
//  Tipper
//
//  Created by Nicholas Russo on 5/8/17.
//  Copyright © 2017 narusso. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITextViewDelegate{
    

    @IBOutlet var flashLight: UIButton!
    @IBOutlet var calcButton: UIButton!
    @IBOutlet var dollarSign: UILabel!
    @IBOutlet var tipControl: UISegmentedControl!
    @IBOutlet var billAmount: UITextField!
    @IBOutlet var splitTable: UITableView!
    var count = 1;
    var tipPercent = 0.18;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        splitTable.dataSource = self;
        billAmount.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let splitNum = cell.contentView.viewWithTag(1) as! UILabel
        splitNum.text = "\(indexPath.row + 1)"
        let amountLabel = cell.contentView.viewWithTag(2) as! UILabel
        let tipIndex = tipControl.selectedSegmentIndex
        if (tipIndex == 1)
        {
            tipPercent = 0.2
        }
        else if (tipIndex == 2)
        {
            tipPercent = 0.25
        }
        else
        {
            tipPercent = 0.18
        }
        var amount = 0.0
        if let text = billAmount.text, !text.isEmpty
        {
            amount = Double(text)!
        }
        let billSplit = (amount/Double(indexPath.row + 1))
        let tip = billSplit*tipPercent
        amountLabel.text = String(format: "%.2f" , billSplit + tip)
        
        return cell
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false;
        }
        splitTable.reloadData()
        return true;
    }
    
    @IBAction func billChanged(_ sender: Any) {
        splitTable.reloadData()

    }
    @IBAction func calcTip(_ sender: Any) {
        billAmount.resignFirstResponder()
        splitTable.reloadData()
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        billAmount.endEditing(true)
    }

    @IBAction func toggleFlashLight(_ sender: Any) {
        if let currentDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), currentDevice.hasTorch {
            do {
                try currentDevice.lockForConfiguration()
                let torchOn = currentDevice.torchMode == AVCaptureTorchMode.on
                if torchOn
                {
                    currentDevice.torchMode = AVCaptureTorchMode.off
                }
                else
                {
                    try currentDevice.setTorchModeOnWithLevel(1.0)//Or whatever you want
                    currentDevice.torchMode = AVCaptureTorchMode.on
                }
                currentDevice.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }

}

