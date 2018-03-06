//
//  ViewController.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-05.
//  Copyright © 2018 Conor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tabelView: UITableView!
    let tootReuseID = "toot"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabelView.register(UINib(nibName: "TableTootsTooCell", bundle: nil) , forCellReuseIdentifier: tootReuseID)
        
        downloadJSON(urlString: "https://api.myjson.com/bins/18y459") //Hardcoded strings?!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            
            self.parseData(data: data)
            
        }
        
        
        print("Sending Request")
        task.resume()
    }
    
    func parseData(data:Data?) {
        guard let usableData = data else { return }
        guard let json = try? JSONSerialization.jsonObject(with: usableData, options: []) else { return }
        guard let jsonDictionary = json as? Dictionary<String,Any> else { return }
        guard let sections = jsonDictionary["sections"] as? [Dictionary<String,Any>] else { return }
        
        parseSections(sections: sections)
    }
    
    func parseSections(sections:[Dictionary<String,Any>]) {
        //Next week!
    }

}

