//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//


//TODOLIST
//neverending operation inputs
//sci notation
//trim calc results to 7 chars

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    var numStack: [Double] = []
    var operStack: [String] = []
    
    var dispTotal = "0"
    var operLastHit = false
    var isDouble = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
        resultLabel.text = "0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        var label = content
        if (content.characters.count > 7) {
            let idx = content.index(content.startIndex, offsetBy: 7)
            label = content.substring(to: idx)
        }
        
        print("Updated result label to \(label)")
        resultLabel.text = label
    }
    
    
    //Flooring method for Doubles with Int equivalent
    func intEquiv(t: Double) -> String {
        let rem = t.truncatingRemainder(dividingBy: 1.0)
        
        if (rem == 0) {
            isDouble = false
            return String(Int(floor(t)))
        }
        isDouble = true
        return String(t)
    }
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: Double, b:Double, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        if (operation == "+") {
            return a + b
        }
        if (operation == "-") {
            return a - b
        }
        if (operation == "*") {
            return a * b
        }
        if (operation == "/") {
            return a / b
        }
        return 0.0
    }
    
    //If the operation isn't an "others" symbol, do stack stuff
    func doCalc(oper: String) {
        var disp = Double(dispTotal)!
        if operLastHit {
            operStack.removeLast()
            operStack.append(oper)
        } else if !(numStack.isEmpty || operStack.isEmpty) {
            while !(numStack.isEmpty || operStack.isEmpty) {
                disp = calculate(a: numStack.removeLast(), b: disp, operation: operStack.removeLast())
                print("Calc numstack: \(numStack)")
                print("Calc operstack: \(operStack)")
            }
            if (oper != "=") {
                operStack.append(oper)
            }
            numStack.append(disp)
            dispTotal = intEquiv(t: disp)
            updateResultLabel(dispTotal)
        } else {
            print("One of the stacks was empty and things were appended")
            if (operStack.isEmpty && !numStack.isEmpty) { //leftover value from last calculation
                operStack.append(oper)
            } else {
                numStack.append(disp)
                if (oper != "=") {
                    operStack.append(oper)
                }
            }
        }
        print("Current numstack: \(numStack)")
        print("Current operstack: \(operStack)")
        dispTotal = "0"
        if (oper != "=") {
            operLastHit = true
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        if (dispTotal.characters.count >= 7) {
            print("input is too large")
            return
        }
        isDouble = false
        //Entering new number and disregarding old answer, clear numstack
        if operStack.isEmpty {
            print("**Numstack cleared**")
            numStack = []
        }
        
        let val = sender.content
        if (dispTotal == "0") {
            dispTotal = val
        } else {
            dispTotal.append(val)
        }
        updateResultLabel(dispTotal)
        operLastHit = false
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        guard String(sender.content) != nil else { return }
        print("The operator \(sender.content) was pressed")
        let val = sender.content
        if (val == "C") {
            dispTotal = "0"
            isDouble = false
            operLastHit = false
            numStack = []
            operStack = []
            updateResultLabel(dispTotal)
        } else if (val == "+/-") {
            var disp = Double(dispTotal)!
            if (disp > 0 && dispTotal.characters.count < 7) {
                dispTotal = "-" + "\(dispTotal)"
                disp = disp * -1.0
                updateResultLabel(dispTotal)
            } else if (disp < 0) {
                dispTotal = String(dispTotal.characters.dropFirst())
                updateResultLabel(dispTotal)
                disp = abs(disp)
            }
            operLastHit = false
        } else if (val == "%") {
            let perc = Double(dispTotal)! / 100.0
            isDouble = true
            dispTotal = intEquiv(t: perc)
            updateResultLabel(dispTotal)
            operLastHit = false
        } else {
            doCalc(oper: val)
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        guard String(sender.content) != nil else { return }
        print("The button for \(sender.content) was pressed")
        if (dispTotal.characters.count >= 7) {
            print("input is too large")
            return
        }
        
        let val = sender.content
        if (val == "0" && dispTotal != "0") {
            dispTotal.append("0")
        } else if (val == "." && isDouble == false) {
            dispTotal.append(val)
            isDouble = true
        }
        
        updateResultLabel(dispTotal)
        operLastHit = false
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

