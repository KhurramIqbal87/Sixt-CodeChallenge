//
//  BaseViewController.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import UIKit

class BaseViewController<T: BaseViewModel> : UIViewController   {
    
    //MARK: - StoredProperties
    
    let viewModel: T
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       
        let activityIndicator =  UIActivityIndicatorView.init(frame: self.view.frame)
        activityIndicator.style = .large
        activityIndicator.color = .red
        return activityIndicator
        
    }()
    
    //MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.activityIndicator)

    }
    
    //MARK: - Initializers
    init(T: T, nibName: String?){
        
        self.viewModel = T
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}

//MARK: - Helper Functions
extension BaseViewController{
   
    func showError(title: String?, message: String?){
       
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       
        let okAction = UIAlertAction.init(title: "OK", style: .default) {[weak alertController] _ in
            alertController?.dismiss(animated: true, completion: nil)
        }
   
        alertController.addAction(okAction)
       
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader(){
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
