//
//  CarListViewController.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//


import UIKit
import Combine
/// CarListviewController show car list on listview
/// it also show error receive on network calls
/// it has a pull to refresh to reload data on list view
final class CarListViewController<T: CarListViewModelType>: BaseViewController<T> {
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //    MARK: - Properties
    
    private var cancelables: Set<AnyCancellable> = []
    private  var refreshControl = UIRefreshControl()
    
    private let adpaterSubject = PassthroughSubject<[[CarListItemViewModelType]],Never>()
    
    private var adapter : CarListAdapter!
    //    MARK: - Initializers
    
    /// initialize view Controller manually
   
    init(viewModel: T){
        super.init(T: viewModel  , nibName: "CarListViewController")
    }
    
    // viewModel is required from outside for lose coupling
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = self.viewModel.getTitle()
    }
    
    //    MARK: - Functions
    
    // initial setup helps in setuping up intial call to viewmodel and subscribing viewmodel publishers to get our data stream. it
    // as soon we get data from viewModel Publisher viewController sends data to adapter using Subject.send
    
    private func initialSetup(){
        
        
        self.viewModel.viewDidLoad()
        
        self.adapter = CarListAdapter.init(items: [[]], tableView: self.tableView, dataSubject: self.adpaterSubject)
        
        self.viewModel.itemsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] carList in
                self?.adpaterSubject.send([carList])
                
            }
            .store(in: &cancelables)
        self.viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] loading in
                if loading{
                    self?.showLoader()
                }else{
                    self?.hideLoader()
                    self?.endRefreshing()
                    
                }
            }
            .store(in: &cancelables)
        self.viewModel.errorPublisher
            .receive(on:RunLoop.main)
            .sink { [weak self] error in
                if error.isEmpty{return}
                self?.showError(title: "Error", message: error)
                DispatchQueue.main.async {[weak self] in
                    self?.endRefreshing()
                }
            }
            .store(in: &cancelables)
        self.setupRefreshControl()
        self.adapter.delegate = self
    }
    
    private func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Data")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not re
    }
    @objc private func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.viewModel.refresh()
    }
    
    private func endRefreshing(){
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension CarListViewController: ListViewAdapterDelegate{
    
    /// on click of list item if we want to navigate or do any thing this will be the handler for item click
    func didSelectRowAt(indexPath: IndexPath) {
        
    }
}
