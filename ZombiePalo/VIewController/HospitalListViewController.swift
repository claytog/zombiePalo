//
//  HospitalListViewController.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit

class HospitalListViewController: UIViewController {
    
    @IBOutlet weak var hospitalListTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!

    var hospitalList: [Hospital] = []
    
    var selectedSeverity: Severity!
    
    let HOSPITALLISTCELL = "HospitalListCell"
    let HOSPITALSEGUE = "HospitalSegue"
    
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hospitalListCell = UINib(nibName: HOSPITALLISTCELL, bundle: nil)
        hospitalListTableView.register(hospitalListCell, forCellReuseIdentifier: HOSPITALLISTCELL)
        hospitalListTableView.tableFooterView = UIView(frame: .zero) // hides empty rows
        
    //    setRefreshControl()
        doFullRefresh(completion: {success in
            self.renderHospitalList()
        })
       
    }
    
//    func setRefreshControl(){
//        refreshControl = UIRefreshControl()
//        hospitalListTableView.refreshControl = refreshControl
//        refreshControl?.tintColor = UIColor.systemGreen
//        refreshControl?.addTarget(self, action: #selector(doFullRefresh), for: .valueChanged)
//    }
    
    @objc func doFullRefresh(completion : @escaping (Bool)->()){

//        let font = UIFont.systemFont(ofSize: 14)
//        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.purple]
//
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "Checking waiting lists", attributes: attributes)
        messageLabel.text = ""
        
        if Connectivity.isConnectedToInternet {
        
            Util.shared.showActivityIndicator(self)

        }else{
            messageLabel.text = "ZOMBIES MAY BE MESSING WITH THE INTERNET"
}
        
        ZombieAPI.shared.fetchHospitals(completion:  { success in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.refreshControl?.endRefreshing()
                self.renderHospitalList()
                Util.shared.hideActivityIndicator()
            }
        })

    }
    
    @IBAction func didPressRefresh(_ sender: Any) {
        doFullRefresh(completion: {success in
            self.renderHospitalList()
        })
        
    }
    
    func renderHospitalList(){
        
        Hospital.getAll(severity: selectedSeverity, completion: { hospitalList in
            self.hospitalList = hospitalList
            self.hospitalListTableView.reloadData()
        })
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destViewController = segue.destination as? HospitalViewController {
            destViewController.selectedHospital = sender as? Hospital
            destViewController.selectedSeverity = selectedSeverity
       }
    }
}
// MARK: - charListTableView delegate methods
extension HospitalListViewController:  UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hospitalList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hospital = hospitalList[indexPath.row]
        
        let cell:HospitalListCell = tableView.dequeueReusableCell(withIdentifier: HOSPITALLISTCELL, for: indexPath) as! HospitalListCell
        
        cell.setupView(hospital: hospital, severity: selectedSeverity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let selectedHospital = hospitalList[indexPath.row]
        
        performSegue(withIdentifier: HOSPITALSEGUE, sender: selectedHospital)
        
    }
    
    
}
