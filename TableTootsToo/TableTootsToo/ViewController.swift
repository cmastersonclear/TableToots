//
//  ViewController.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-05.
//  Copyright © 2018 Conor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let tootReuseID = "toot"
    
    var dataModel:KittyDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: "TableTootsTooCell", bundle: nil) , forCellReuseIdentifier: tootReuseID)
        
        downloadJSON(urlString: "https://api.myjson.com/bins/mbn8h") //Hardcoded strings?!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel?.sectionArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.sectionArray?[section].cellArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toot") else { return UITableViewCell() }
        
        cell.backgroundColor = .red
        
        return cell
    }
    

    func downloadJSON(urlString:String) {
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            print("Response recieved")
            
            if let error = error {
                print("ERROR:\(error)" )
                return
            }
            
            let dataModel = self.parseData(data: data)
            self.dataModel = dataModel
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
        print("Sending Request")
        task.resume()
    }
    
    func parseData(data:Data?) -> KittyDataModel? {
        guard let usableData = data else { return nil}
        guard let json = try? JSONSerialization.jsonObject(with: usableData, options: []) else { return nil }
        guard let jsonDictionary = json as? Dictionary<String,Any> else { return nil }
        guard let sections = jsonDictionary["sections"] as? [Any] else { return nil }
        
        let dataModel = KittyDataModel()
        
        dataModel.sectionArray = parseSections(sections: sections)
        
        return dataModel
    }
    
    func parseSections(sections:[Any]) -> [SectionModel] {
        
        var sectionArray = [SectionModel]()
        
        for section in sections {
            guard let section = section as? [Dictionary<String,String>] else { continue }
            
            let newSectionModel = SectionModel()
            
            newSectionModel.cellArray = parseRowsInSection(section: section)
            
            sectionArray.append(newSectionModel)
        }
        
        return sectionArray
    }
    
    func parseRowsInSection(section:[Dictionary<String,String>]) -> [CellViewModel] {
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

class CellViewModel {
    var title:String?
    var subTitle:String?
    var imageURLString:String?
}

class SectionModel {
    var cellArray:[CellViewModel]?
}

class KittyDataModel {
    var sectionArray:[SectionModel]?
}

