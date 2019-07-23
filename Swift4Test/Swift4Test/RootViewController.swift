//
//  RootViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/18.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import SideMenuSwift

class RootViewController: UITableViewController,SideMenuManagerViewControllerDelegate {

    var sideMenu:SideMenuController!
    var sideManager : CoverMenuManagerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let vc = Tools.VCWithIdentifier(identifier: "test", storyBoradName: "Segue")
        let vc = UIViewController.init()
        vc.view.backgroundColor = .yellow
        sideManager = CoverMenuManagerViewController.init(menuViewController: vc, parentVC: self)
        sideManager.bind(delegate: self)
    }



    @IBAction func test(_ sender: Any) {
        if(sideManager.hadShow){
            sideManager.dismissMenuViewController()
        }
        else{
            sideManager.presentMenuViewController()
        }
        
    }
    
    func menuDidAppear() {
        
    }
    
    func menuDidDisappear() {
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
