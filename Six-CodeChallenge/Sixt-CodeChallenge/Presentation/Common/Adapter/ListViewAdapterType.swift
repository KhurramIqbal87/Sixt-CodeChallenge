//
//  ListViewAdapterType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
protocol ListViewAdapterDelegate: AnyObject{
    func didSelectRowAt(indexPath: IndexPath)
}
/// at times we want to change the list view type to different scroll type so this will help us to abstract the viewcontroller from knowing the implementation
protocol ListViewAdapterType: AnyObject{
    associatedtype ModelType
    
    var items: [[ModelType]]{get set}
    var delegate: ListViewAdapterDelegate? {get set}
}
