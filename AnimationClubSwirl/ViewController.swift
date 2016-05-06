//
//  ViewController.swift
//  AnimationClubSwirl
//
//  Created by Liz Vanderkloot on 5/6/16.
//  Copyright © 2016 lizvdk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var swirlView: Swirl!
    @IBOutlet weak var playAnimationButton: UIButton!

    var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swirlView.layer.cornerRadius = swirlView.bounds.width / 2
    }

    @IBAction func playAnimationButtonPressed(sender: UIButton) {
        if isAnimating {
            swirlView.stopAnimatingSwirl()
            playAnimationButton.setTitle("▶︎", forState: .Normal)
            isAnimating = false
        } else {
            swirlView.animateSwirl()
            playAnimationButton.setTitle("▦", forState: .Normal)
            isAnimating = true
        }

    }
}

