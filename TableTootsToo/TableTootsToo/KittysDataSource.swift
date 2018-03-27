//
//  KittysDataSource.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-14.
//  Copyright © 2018 Conor. All rights reserved.
//

import Foundation
import UIKit

class KittysDataSource { // A DataSource takes care of gathering all the data so the rest of your code doesn't need to care where the data comes from.
    //This is nice because, imagine you are 3 days from release and you need to change data provider, now all the code that needs to be changed is in one place, not strewn around your code.
    static func getKittyData(delegate: KittyDataModelReadyDelegate) {
        
        guard let requestUrl = URL(string:"https://api.myjson.com/bins/mbn8h") else { return }
        let request = URLRequest(url:requestUrl)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print("ERROR:\(error)" )
                return
            }
            
            let parsedData = self.parseData(data: data)
            delegate.kittyDataModelReady(dataModel: parsedData)
        }.resume()
    }
    
    static func parseData(data:Data?) -> KittyDataModel? {
        guard let usableData = data else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: usableData, options: []) else { return nil }
        guard let jsonDictionary = json as? Dictionary<String,Any> else { return nil }
        guard let sections = jsonDictionary["sections"] as? [Any] else { return nil }
        
        let dataModel = KittyDataModel()
        dataModel.sectionArray = parseSections(sections: sections)
        
        return dataModel
    }
    
    static func parseSections(sections:[Any]) -> [SectionModel] {
        
        var sectionArray = [SectionModel]()
        
        for section in sections {
            guard let section = section as? [Dictionary<String,String>] else { continue }
            let newSectionModel = SectionModel()
            
            newSectionModel.cellArray = parseRowsInSection(section: section)
            
            sectionArray.append(newSectionModel)
        }
        
        return sectionArray
    }
    
    static func parseRowsInSection(section:[Dictionary<String,String>]) -> [CellViewModel] {
        var cellArray = [CellViewModel]()
        
        for cell in section {
            let cellModel = CellViewModel()
            cellModel.title = cell["title"]
            cellModel.subTitle = cell["subTitle"]
            cellModel.imageURLString = cell["imageURL"]
            
            cellArray.append(cellModel)
        }
        
        return cellArray
    }
}

class KittyDataModel {
    var sectionArray:[SectionModel]?
}

class SectionModel {
    var cellArray:[CellViewModel]?
}

class CellViewModel {
    var title:String?
    var subTitle:String?
    var imageURLString:String?
}

protocol KittyDataModelReadyDelegate {
    func kittyDataModelReady(dataModel: KittyDataModel?)
}
