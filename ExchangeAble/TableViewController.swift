//
//  TableViewController.swift
//  ExchangeAble
//
//  Created by Antonius George on 27/09/18.
//  Copyright © 2018 Atn010. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate {
	@IBOutlet weak var userCurrency: UITextField!
	
	@IBOutlet var tables: UITableView!
	

	
// GET https://api.exchangeratesapi.io/latest?base=USD HTTP/1.1
	
	var currencyData = ["IDR"]
	var selectedCurrency = "IDR"
	var Rates:[String:Double] = ["IDR":0.1]

		let currencyPicker = UIPickerView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		checkNewData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		
		
		currencyPicker.delegate = self
		currencyPicker.dataSource = self
		
		tables.delegate = self
		tables.dataSource = self
		
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
		
		toolBar.setItems([doneButton], animated: false)

		toolBar.isUserInteractionEnabled = true
		
		
		
		userCurrency.inputView = currencyPicker
		userCurrency.inputAccessoryView = toolBar
		
		userCurrency.text = "IDR"
    }
	
	@objc func donePicker(){
		userCurrency.text = selectedCurrency
		userCurrency.resignFirstResponder()
		checkNewData()
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
		
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 	currencyData.count
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyData[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedCurrency = currencyData[row]
	}
	
	
	
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencyData.count
    }
	
	

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell


		cell.Currency.text = currencyData[indexPath.row]
		cell.Rate.text = String(format: "%.3f", Rates[currencyData[indexPath.row]] ?? -1)
		
		//"\(Rates[currencyData[indexPath.row]] ?? -1)"
		
        // Configure the cell...

        return cell
    }
	
	
	func checkNewData() {
	
		
		guard let rateURL = URL(string: "https://api.exchangeratesapi.io/latest?base=" + selectedCurrency) else { return }
		
		URLSession.shared.dataTask(with: rateURL) { (data, response
			, error) in
			
			if let unwrapperError = error{
				print("URLSession Error = /n \(unwrapperError.localizedDescription)")
			}else if let unwrappedData = data{
				
				do{
					let jsonFile = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
					
					
					if let jsonDictionary = jsonFile as? [String:Any]{
						
						//print(jsonDictionary["rates"]!)
						if let rateData = jsonDictionary["rates"] as? [String:Double]{
							
							self.Rates.removeAll()
							self.currencyData.removeAll()
							
							
							
							self.Rates = rateData
							self.currencyData = Array(rateData.keys).sorted()
							
						
							
							DispatchQueue.main.async {
								self.tables.reloadData()
								self.currencyPicker.reloadAllComponents()
								
							}
							
							
							print(self.currencyData)
							print(rateData)
							
							
						}
						
						
						
						DispatchQueue.main.async {
							
							//self.labelText.text = "\(jsonDictionary["url"]!)\n\(jsonDictionary["origin"]!)"
							//"\(response)"
						}
					}
					
					
				}catch{
					print("Error Converting code")
				}
				
				
				
			}
			
			}.resume()
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
