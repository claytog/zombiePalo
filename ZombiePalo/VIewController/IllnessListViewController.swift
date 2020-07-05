//
//  IllnessListViewController.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit

class IllnessListViewController: UIViewController {
    
    @IBOutlet weak var illnessListTableView: UITableView!

    var illnessList: [Illness] = []
    
    let ILLNESSLISTCELL = "IllnessListCell"
    let SEVERITYSEGUE = "SeveritySegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        illnessListTableView.tableFooterView = UIView(frame: .zero) // hides empty rows
        
        let illnessListCell = UINib(nibName: ILLNESSLISTCELL, bundle: nil)
        illnessListTableView.register(illnessListCell, forCellReuseIdentifier: ILLNESSLISTCELL)
        
        loadData()

    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destViewController = segue.destination as? SeverityViewController {
            destViewController.selectedIllness = sender as? Illness
       }
    }
    
    func loadData() {
           
        Util.shared.showActivityIndicator(self)
       
        let group = DispatchGroup()
    
        group.enter()
        DispatchQueue.global().async {
           ZombieAPI.shared.fetchHospitals(completion: { hospitalList in
               group.leave()
           })
        }

        group.enter()
        DispatchQueue.global().async {
           ZombieAPI.shared.fetchIllnesses(completion: { hospitalList in
               group.leave()
           })
        }

        group.enter()
        DispatchQueue.global().async {
           ZombieAPI.shared.fetchIllnesses(completion: { hospitalList in
               group.leave()
           })
        }

        group.enter()
        DispatchQueue.global().async {
           ZombieAPI.shared.fetchSeverity(completion: { severityList in
               group.leave()
           })
        }

        group.notify(queue: .main) {
           
            self.illnessList = Illness.getAll()
            self.illnessListTableView.reloadData()
            Util.shared.hideActivityIndicator()
        }
   }
    

}
// MARK: - charListTableView delegate methods
extension IllnessListViewController:  UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return illnessList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0}
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let illness = illnessList[indexPath.section]
        
        let cell:IllnessListCell = tableView.dequeueReusableCell(withIdentifier: ILLNESSLISTCELL, for: indexPath) as! IllnessListCell
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.systemGray5
        
        cell.setupView(illness: illness)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let selectedIllness = illnessList[indexPath.section]
        
        performSegue(withIdentifier: SEVERITYSEGUE, sender: selectedIllness)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
      
        headerView.backgroundColor = UIColor.clear
      
        return headerView
    }
    
}
