//
//  TabBarViewController.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import UIKit

class TabBarViewController <ViewModelType: TabBarViewModelType>: UITabBarController {
    
    private let viewModel: ViewModelType
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    init(viewModel: ViewModelType ){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
