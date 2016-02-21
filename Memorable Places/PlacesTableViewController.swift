//
//  PlacesTableViewController.swift
//  Memorable Places
//
//  Created by iPicnic Digital on 2/14/16.
//  Copyright © 2016 Dyego Silva. All rights reserved.
//

import UIKit
import CoreLocation



class PlacesTableViewController: UITableViewController
{
    var places: [Place]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        places = UserDefaultsHelper.loadMyData()
        
        if places.count == 0
        {
            places.append(Place(name: "Taj Mahal", coordinate: CLLocationCoordinate2DMake(27.1750151, 78.0399665)))
            UserDefaultsHelper.saveMyData(arrayOfpalces: places)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        places = UserDefaultsHelper.loadMyData()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath)

        cell.textLabel?.text = places[indexPath.row].name
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            places.removeAtIndex(indexPath.row)
            UserDefaultsHelper.saveMyData(arrayOfpalces: places)
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }  
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier(SegueIdentifier.FindPlace, sender: self)
    }

    // MARK: - Navigation
    
    struct SegueIdentifier
    {
        static let AddPlace = "goMap"
        static let FindPlace = "findPlace"
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let vc = segue.destinationViewController as? MapViewController
        {
            if let identifier = segue.identifier
            {
                switch(identifier)
                {
                case SegueIdentifier.AddPlace:
                    vc.placesArray = places
                case SegueIdentifier.FindPlace:
                    let indexPath = tableView.indexPathForSelectedRow
                    vc.place = places[indexPath!.row]
                    default: break
                }
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
