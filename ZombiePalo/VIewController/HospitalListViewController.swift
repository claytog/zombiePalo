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

    var hospitalList: [Hospital?] = [Hospital?](repeating: nil, count: 10)
    
    var selectedSeverity: Severity!
    
    let HOSPITALLISTCELL = "HospitalListCell"
    let HOSPITALSEGUE = "HospitalSegue"
    
    private var refreshControl: UIRefreshControl?
    
    var currentPage: Int = 0
    var totalPages:Int = 0
    
    private var isFetchInProgress: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hospitalListTableView.prefetchDataSource = self
        
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
        
        ZombieAPI.shared.fetchHospitals(limit: 10, page: 0, completion:  { success in
            
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
                
        let cell:HospitalListCell = tableView.dequeueReusableCell(withIdentifier: HOSPITALLISTCELL, for: indexPath) as! HospitalListCell
        
        // get the corresponding news object to show from the array
        if let hospital = hospitalList[indexPath.row]  {
          cell.setupView(hospital: hospital, severity: selectedSeverity)
        } else {
          // init labels
          cell.truncateView()
          print("fetchAPI")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let selectedHospital = hospitalList[indexPath.row]
        
        performSegue(withIdentifier: HOSPITALSEGUE, sender: selectedHospital)
    }
    
}
// MARK: - prefetching delegate methods
extension HospitalListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetching row of \(indexPaths)")

        if !self.isFetchInProgress && currentPage <= totalPages{
            print("fetching")
            isFetchInProgress = true
            ZombieAPI.shared.fetchHospitals(limit: 10, page: currentPage, completion:  { zombieHospitalList in
                if let hospitalList = zombieHospitalList?.list {
                    for hospital in hospitalList.hospitals {
                        self.hospitalList.append(hospital)
                    }
                    self.renderHospitalList()
                }
                if let number = zombieHospitalList?.page.number {
                    self.currentPage = number + 1
                }
                if let totalPages = zombieHospitalList?.page.totalPages {
                    self.totalPages = totalPages
                }
                self.isFetchInProgress = false
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
      
       // cancel the task of fetching news from API when user scroll away from them
//       for indexPath in indexPaths {
//         self.cancelFetchNews(ofIndex: indexPath.row)
//       }
     }
    
}

