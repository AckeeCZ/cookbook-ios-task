//
//  DetailViewController.swift
//  Cookbook-Test-Project
//
//  Created by Dominik Vesely on 12/01/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var detailItem: Date? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    // MARK: Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    // MARK: Private API

    private func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
}
