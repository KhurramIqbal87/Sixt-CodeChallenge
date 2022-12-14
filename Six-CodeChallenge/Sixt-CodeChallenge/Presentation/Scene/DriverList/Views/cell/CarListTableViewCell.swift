//
//  CarListTableViewCell.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import UIKit
import MapKit
protocol BaseTableViewCell {
    func setup(viewModel: Any)
}

final class CarListTableViewCell: UITableViewCell,BaseTableViewCell {
   
    private var viewModel: CarListItemViewModelType? {
        didSet{
            
            if let carListItemViewModel = viewModel{
                self.prepareUI(viewModel: carListItemViewModel)
            }
        }
    }
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet private weak var vehicleTypeImageView: UIImageView?
    @IBOutlet private weak var licencePlateLabel: UILabel?
    @IBOutlet private weak var vehicleTypeLabel: UILabel?
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var fuelTypeLabel: UILabel?
    @IBOutlet private weak var transmissionTypeLabel: UILabel?
    @IBOutlet private weak var cleanTypeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(viewModel: Any) {
        
        if let carListModel = viewModel as? CarListItemViewModelType {
            
            self.viewModel = carListModel
            
            self.prepareUI(viewModel: carListModel)
            
            self.containerView?.layer.borderColor  = UIColor.orange.cgColor
            self.containerView?.layer.cornerRadius = 4
            self.containerView?.layer.borderWidth = 2
          
            self.contentView.layer.masksToBounds = true
            
        }
    }
    private  func prepareUI(viewModel: CarListItemViewModelType){
       
        self.vehicleTypeLabel?.text = viewModel.getType()
        self.licencePlateLabel?.text = viewModel.getLicensePlate()
    
        
        self.nameLabel?.text = viewModel.getName()
        self.transmissionTypeLabel?.text = viewModel.getTransmissionType()
        self.fuelTypeLabel?.text = viewModel.getFuelType()
        self.cleanTypeLabel?.text = viewModel.getCleaniness()
        self.vehicleTypeImageView?.image = nil
        self.vehicleTypeImageView?.backgroundColor = .black
        self.vehicleTypeImageView?.roundCorner()
        self.vehicleTypeImageView?.layer.borderWidth = 1
        self.vehicleTypeImageView?.layer.borderColor = UIColor.orange.cgColor
    
        viewModel.getImage { [weak self] imageData in
          
            if let imageData = imageData, let image = UIImage.init(data: imageData){
                DispatchQueue.main.async {
                    self?.vehicleTypeImageView?.image = image
                    self?.vehicleTypeImageView?.backgroundColor = .clear
                }
            }else{
                DispatchQueue.main.async {
                    self?.vehicleTypeImageView?.backgroundColor = .black
                }
            }
        }
        
        
    }

}

