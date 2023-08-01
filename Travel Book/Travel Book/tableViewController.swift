//
//  tableViewController.swift
//  Travel Book
//
//  Created by midDeveloper on 23.07.2023.
//

import UIKit
import CoreData

class tableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var chosenTitle = String()
    var chosenTitleId = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(goAddPage))
        
        
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @objc func goAddPage(){
        chosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    @objc func getData() {
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        self.titleArray.removeAll(keepingCapacity: false)
        self.idArray.removeAll(keepingCapacity: false)
        
        do{
            let results = try  context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let title = result.value(forKey: "title") as? String{
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        self.idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        }catch{
            print("ERROR")
        }
        print(titleArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.idArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenTitleId = idArray[indexPath.row] as! UUID
        self.chosenTitle = titleArray[indexPath.row] as! String
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController"{
            let destVc = segue.destination as! ViewController
            destVc.selectedTitle = self.chosenTitle
            destVc.selectedTitleId = self.chosenTitleId
        }
    }
    

}
