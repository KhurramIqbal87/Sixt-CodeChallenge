//
//  Filing.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
final class Filing: NSObject, FilingType{
    
    static let sharedInstance = Filing.init()
    private override init(){
        super.init()
    }
    func saveFile(data: Data, fileName: String, fileExtension: String){
        
        self.save(data: data, toDirectory: self.documentDirectory(), withFileName:   fileName)
    }
    
    
     func getFile(fileName: String)->Data?{
        
         
         return self.read(fromDocumentsWithFileName: fileName)
      
    }
    func getLocalStorageFileURL(fileName: String)->URL?{
        let fileNameURL = URL(fileURLWithPath: fileName).lastPathComponent
        
        guard let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: fileNameURL), let url = URL(string: filePath) else {return nil}
        return url
    }
    private func read(fromDocumentsWithFileName fileName: String) -> Data? {
        let fileNameURL = URL(fileURLWithPath: fileName).lastPathComponent
        
        guard let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: fileNameURL), let url = URL(string: filePath) else {return nil}
        
        do {
            let data = try Data(contentsOf: url)
            
            return data
        } catch {
            print("Error reading saved file")
            return nil
           
        }
    }
    
   private  func save(data: Data ,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName), let url = URL(string: filePath) else {
            return
        }
        
        do {
            
            try data.write(to: url, options: .atomic)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    private func documentDirectory() -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return documentDirectory[0].absoluteString
    }
}


protocol FilingType{
    func saveFile(data: Data, fileName: String, fileExtension: String)
    func getFile(fileName: String)->Data?
}
