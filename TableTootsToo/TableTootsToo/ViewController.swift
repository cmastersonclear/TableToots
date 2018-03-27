//
//  ViewController.swift
//  TableTootsToo
//
//  Created by Conor on 2018-03-05.
//  Copyright © 2018 Conor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KittyDataModelReadyDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullsizeImageContainerView: UIView!
    @IBOutlet weak var fullsizeImageview: UIImageView!
    
    let tootReuseID = "toot"
    var tableViewData:KittyDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fullsizeImageContainerView.isHidden = true
        
        tableView.register(UINib(nibName: "TableTootsTooCell", bundle: nil) , forCellReuseIdentifier: tootReuseID)
        
        KittysDataSource.getKittyData(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData?.sectionArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.sectionArray?[section].cellArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toot") else { return UITableViewCell() }
        
        if let cellModel = tableViewData?.sectionArray?[indexPath.section].cellArray?[indexPath.row],
            let cell  = cell as? TableTootsTooCell {
            cell.setDataModel(model: cellModel)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.fullsizeImageview.transform = CGAffineTransform.identity
        
        guard let imageURLString = tableViewData?.sectionArray?[indexPath.section].cellArray?[indexPath.row].imageURLString else { return }
        fullsizeImageContainerView.isHidden = false
        fullsizeImageview.setImageWithURLString(urlString: imageURLString)
    }
    
    func kittyDataModelReady(dataModel: KittyDataModel?) {
        DispatchQueue.main.async { //All updates that the user can see MUST be done on the main thread
            self.tableViewData = dataModel
            self.tableView.reloadData()
        }
    }
    
    @IBAction func userDidTouchImageContainer(_ sender: Any) {
        self.fullsizeImageContainerView.isHidden = true
    }
    
    @IBAction func userDidPinchOnImageview(_ sender: Any) {
        guard let recog = sender as? UIPinchGestureRecognizer else { return }
        
        let pinchScale = recog.scale
        recog.scale = 1
        
        fullsizeImageview.transform = fullsizeImageview.transform.scaledBy(x: pinchScale, y: pinchScale)
    }
    
    @IBAction func userDidDragImageView(_ sender: Any) {
        guard let recog = sender as? UIPanGestureRecognizer else { return }
        let dragDelta = recog.translation(in: self.view)
        recog.setTranslation(CGPoint(), in: self.view)
        fullsizeImageview.transform = fullsizeImageview.transform.translatedBy(x: dragDelta.x, y: dragDelta.y)
      
    }
}
