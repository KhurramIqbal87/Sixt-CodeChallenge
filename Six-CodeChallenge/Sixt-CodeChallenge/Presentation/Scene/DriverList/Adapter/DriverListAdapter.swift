//
//  DriverListAdapter.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import Combine
import UIKit

/// Our TableViewAdapter for DriverList
final class DriverListAdapter: NSObject, ListViewAdapterType{
   
    weak var delegate: ListViewAdapterDelegate?
    var cancelable: AnyCancellable!
    private weak var tableView: UITableView?
    typealias ModelType = DriverListItemViewModelType

    var items: [[DriverListItemViewModelType]]  {
        didSet{
            DispatchQueue.main.async {
                self.registerNibs()
                self.tableView?.reloadData()
            }
        }
    }
    private override init(){
        self.items = [[]]
        self.tableView = nil
        super.init()
    }
    init(items: [[ModelType]], tableView: UITableView, dataSubject: PassthroughSubject <[[ModelType]], Never>){
        
        self.items = items
        self.tableView = tableView
        
        super.init()
        self.registerNibs()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.cancelable =  dataSubject.sink { [weak self] items in
            self?.items = items
        }
    
       
    }
    
    private func registerNibs(){
        let identifiers =  self.items.joined().compactMap({ item in
            return item.getReusableIdentifierName()
        })
        
        let uniqueIdentifiers: Set<String> = Set.init(identifiers)
        for reusableIdentifier in uniqueIdentifiers{
            tableView?.register(UINib.init(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
        }
    }
    deinit{
        print("Deinit Adapter class")
    }
}

extension DriverListAdapter: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRowAt(indexPath: indexPath)
    }

}
extension DriverListAdapter: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItems = items[section]
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItems = items[indexPath.section]
        let item  = sectionItems[indexPath.row]
        return CGFloat(item.getHeightForRow())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItems = items[indexPath.section]
        let item  = sectionItems[indexPath.row]
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.getReusableIdentifierName()), let baseCell = cell as? BaseTableViewCell  else{return UITableViewCell.init()}
        baseCell.setup(viewModel: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
   
}
