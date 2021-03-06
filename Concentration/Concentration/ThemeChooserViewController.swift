//
//  ThemeChooserViewController.swift
//  Concentration
//
//  Created by Xuzh on 2019/7/20.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate{

    let themes =
        [
            "Sports": "⚽️🏀🏈⚾️🥎🏐🏉🎾🥏🎱🏓🏸🥅🏒🏑🥍🏏⛳️",
            "Animals": "🐶🐱🐭🐹🐰🦊🦝🐻🐼🦘🦡🐨🐯🦁🐮🐷🐽🐸",
            "Faces": "😤😢😭😦😧😨😩🤯😬😰😱🥵🥶😳🤪😵😡😠"
        ]

    override func awakeFromNib()
    {
        splitViewController?.delegate = self
    }
    
    func splitViewController
        (_ splitViewController: UISplitViewController,
         collapseSecondary secondaryViewController: UIViewController,
         onto primaryViewController: UIViewController) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController
        {
            if cvc.theme == nil
            {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentraionViewController
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                cvc.theme = theme
            }
        }
        else if let cvc = lastSeguedToDetailConcentrationViewController
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else
        {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    private var splitViewDetailConcentraionViewController: ConcentrationViewController?
    {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToDetailConcentrationViewController: ConcentrationViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Choose Theme"
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                if let cvc = segue.destination as? ConcentrationViewController
                {
                    cvc.theme = theme
                    lastSeguedToDetailConcentrationViewController = cvc
                }
            }
        }
    }

}
