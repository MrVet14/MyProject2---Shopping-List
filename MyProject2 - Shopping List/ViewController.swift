//
//  ViewController.swift
//  MyProject2 - Shopping List
//
//  Created by Vitali Vyucheiski on 3/15/22.
//

import UIKit



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}



class ViewController: UITableViewController {
    var listOfItems = [String]()
    var cellNumber = 0
    var listNumber = 0
    var numberOfItemInAList = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareList = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        navigationItem.rightBarButtonItems = [addItemButton, shareList]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clearList))
        
        title = "My Shopping list #\(listNumber)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = listOfItems[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter your item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard var answer = ac?.textFields?[0].text else { return }
            answer = "\(self!.numberOfItemInAList)." + answer.capitalizingFirstLetter()
            self!.numberOfItemInAList+=1
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        listOfItems.insert(answer, at: cellNumber)
        let indexPath = IndexPath(row: cellNumber, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        cellNumber+=1
        print(cellNumber)
    }
    
    @objc func clearList() {
        listNumber+=1
        title = "My Shopping list #\(listNumber)"
        numberOfItemInAList = 1
        listOfItems.removeAll()
        tableView.reloadData()
        cellNumber = 0
    }
    
    @objc func shareTapped() {
        let list = listOfItems.joined(separator: "\n")
        guard var shareListTitle = title else { return }
        shareListTitle += "\n"
        
        let vc = UIActivityViewController(activityItems: [shareListTitle, list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

