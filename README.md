# Sixt-CodeChallenge - MVVM-Clean


## This project is created using Mvvm-Clean in Swift Language. 
 Following Native framework are use 

- Combine
- Codable
- UIKit
- MapKit
- URLSession
- CoreLocation

Code challenge was to show the list of cars in 
- Listview
- MapView

## For List View have used adapter pattern.

``` Swift
extension CarListAdapter{
    
    // MARK: - Helper Functions
    
    private func registerNibs(){
        let identifiers =  self.items.joined().compactMap({ item in
            return item.getReusableIdentifierName()
        })
        
        let uniqueIdentifiers: Set<String> = Set.init(identifiers)
        for reusableIdentifier in uniqueIdentifiers{
            tableView?.register(UINib.init(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
        }
    }
}
extension CarListAdapter: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRowAt(indexPath: indexPath)
    }

}
extension CarListAdapter: UITableViewDataSource{
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
```


## Code is structured in 3 layers

- Presentation
- Data
- Domain


## Dependencies of layer
- PresentationLayer Depends on Domain Layer
- Data Layer Depends on Domain Layer
- Domain layer is independent



## App StartFlow

```Swift

  let window = UIWindow(windowScene: scene)
  self.window = window
  self.appCoordiantor = AppCoordinator.init(window: window)
  appCoordiantor?.start()
  ```
 ## Dependencies are injected at time of creation

``` Swift
 init(viewModel: T){
        super.init(T: viewModel  , nibName: "CarListViewController")
    }
```

``` Swift
init(repository: CarListRepositoryType) {
        self.repository = repository
    }
```

``` Swift
  init(networkManager: ApiClientType = ApiClient.sharedInstance){
        self.networkManager = networkManager
    }
 ```
 
 ``` Swift
 func createCarListViewController()->UIViewController{
     
        let viewController = CarListViewController<CarListViewModel>.init(viewModel: self.createCarListViewModel())
        return viewController
    }
    
     func createCarListViewModel()-> CarListViewModel{
         let CarListViewModel = CarListViewModel.init(repository: self.createCarListRepository())
         
         return CarListViewModel
    }
    
    func createCarListRepository()->CarListRepositoryType{
        let repository = CarListRepository.init(networkManager: ApiClient.sharedInstance)
        return repository
    }
``` 

## Combine is used for reactive approach
 ``` Swift
  var itemsPublisher: Published<[CarListItemViewModelType]>.Publisher{$items}
    
    var loadingPublisher: Published<Bool>.Publisher{$isLoading}
    
    var errorPublisher: Published<String>.Publisher {$showError}
    
 
    
    @Published private var items: [CarListItemViewModelType] = []
    @Published private var isLoading: Bool = false
    @Published private var showError: String = ""
    
     self.isLoading = true
       
     private func getCarList(){
   
        self.isLoading = true
        self.repository.getCarList() { [weak self] Cars, error in
            guard let self = self else{return}
            
            self.isLoading = false
            
            if let error = error{
                self.showError = error
                return
            }
            if let Cars = Cars{
                self.convertModelToViewModels(Cars: Cars)
            }
        }
    }
    
    private func convertModelToViewModels(Cars: CarList){
        
        self.items =  Cars.compactMap { Car in
            return CarListItemViewModel.init(model:Car)
        }
    }
```    
``` Swift    
    self.viewModel.itemsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] Cars in
                self?.adpaterSubject.send([Cars])

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
```
## Codable is used for request encoding and decoding

``` Swift
struct CarListRequest: BaseRequest, Encodable{
   
    //MARK: - StoredProperties
   
    private let path = "codingtask/cars"
    
    
    //MARK: - Implementations
    func getHttpRequestMethod() -> HttpMethod {
        return .get
    }
    
    func getHeaders() -> [String : String]? {
        return  nil
    }
    
    
    func getPath() -> String {
        return self.getBaseUrl() + self.path
    }
}

//MARK: - EncodedKeys

extension CarListRequest{
    
    enum CodingKeys: CodingKey {
    }
}
```
``` Swift
    private func getURLRequest<Request>(path: String, headers: Header?, paramaters: Request?, httpMethod: HttpMethod )->URLRequest? where Request: Encodable{
        
       
        guard let url = URL(string: path) else{return nil}
        var urlRequest = URLRequest(url: url)
        
        /// check if request is non Get type create encode data and attached it to body else convert parameters into queryString and create new URL 
        if let paramData = paramaters, let data = try? JSONEncoder().encode(paramData){
            if httpMethod != .get{
                urlRequest.httpBody = data
            } else{
                if let dict = paramaters?.dictionary, dict.count > 0{
                    var urlComponent = URLComponents.init(string: path)
                    urlComponent?.queryItems =    dict.compactMap { (key,val) -> URLQueryItem in
                        
                        return URLQueryItem.init(name: key, value: val as? String)
                    }
                    urlRequest = URLRequest.init(url: urlComponent?.url ?? url)
                }
            }
            
        }
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
```
 
``` swift
guard let urlRequest = self.getURLRequest(path: request.getPath(), headers: request.getHeaders(), paramaters: request, httpMethod: request.getHttpRequestMethod())else{
            completion(nil, "Invalid Request")
            return
  }
``` 
