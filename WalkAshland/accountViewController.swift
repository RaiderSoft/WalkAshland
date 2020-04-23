//
//  accountViewController.swift
//  WalkAshland
//
//  Created by Faisal Alik on 3/25/20.
//  Copyright © 2020 RaiderSoft. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let str = "Super long string here"
        let filename = getDocumentsDirectory().appendingPathComponent("../../output.txt")
        NSLog("\(FileManager.default)")

        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            NSLog("Called")
        } catch {
            NSLog("Error")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        do {
            let text2 = try String(contentsOf: filename, encoding: .utf8)
            NSLog("\(text2)")
        }
        catch {
            
        }
 
        // Do any additional setup after loading the view.
    }


}

