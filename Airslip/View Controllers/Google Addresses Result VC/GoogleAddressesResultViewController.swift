//
//  GoogleAddressesResultViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 01/03/21.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol SelectedAddressDelegate {
    func getSeletedAddress(selectedAddress:Any)
}
class GoogleAddressesResultViewController: UIViewController {
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    var googlePlacesArray = NSArray.init()
    var seletedAddressDelegate : SelectedAddressDelegate!
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    var placemark: CLPlacemark!
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.mainView.layer.borderWidth = 1
//        self.mainView.layer.borderColor = hexStringToUIColor(hex: LIGHT_BORDER_COLOR).cgColor
        self.noDataImage.isHidden = false
        self.noDataLbl.isHidden = false
        self.tableV.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        self.tableV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        self.searchTextField.delegate = self
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.placeAutocomplete(self.searchTextField.text)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func placeAutocomplete(_ searchStr: String?) {
        placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "UK"
        
        placesClient.findAutocompletePredictions(fromQuery: searchStr!, filter: filter, sessionToken: nil) { results, error in
            if error != nil {
                print("Autocomplete error \(error?.localizedDescription ?? "")")
                return
            }
            if results?.count == 0 || results == nil {

            } else {
                print(results! as NSArray)
                self.googlePlacesArray = [Any]() as NSArray
                self.googlePlacesArray = results! as NSArray
          
                if self.googlePlacesArray.count > 0 {
                    self.noDataImage.isHidden = true
                    self.noDataLbl.isHidden = true
                    self.tableV.isHidden = false
                }
                else {
                    self.noDataImage.isHidden = false
                    self.noDataLbl.isHidden = false
                    self.tableV.isHidden = true
                }
                self.tableV.reloadData()
            }
        }
    }
    
    
}

extension GoogleAddressesResultViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.googlePlacesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "cell")
        }
        let result: GMSAutocompletePrediction? = googlePlacesArray.object(at: indexPath.row) as? GMSAutocompletePrediction
        print(result as Any)
        
        
        if let primaryAddress = result?.attributedPrimaryText.string
        {
            cell?.textLabel?.text  = primaryAddress
            if let aSize = UIFont(name: REGULAR_FONT, size: 16) {
                cell?.textLabel?.font = aSize
            }
        }
        if let secondaryAddress = result?.attributedSecondaryText?.string
        {
            cell?.detailTextLabel?.text = secondaryAddress
            if let aSize = UIFont(name: REGULAR_FONT, size: 12) {
                cell?.detailTextLabel?.font = aSize
            }
        }
//        cell?.imageView?.image = #imageLiteral(resourceName: "icon-pointer")
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultMain: GMSAutocompletePrediction? = googlePlacesArray.object(at: indexPath.row) as? GMSAutocompletePrediction
        print(resultMain?.attributedPrimaryText.string as Any)
        DispatchQueue.main.async(execute: {
            
            let placeClient = GMSPlacesClient.shared() as? GMSPlacesClient
            placeClient?.lookUpPlaceID((resultMain?.placeID)!, callback: { result, error in
                if error == nil {
                    if let aLatitude = result?.coordinate.latitude, let aLongitude = result?.coordinate.longitude {
                        print("place : \(aLatitude),\(aLongitude)")
                    }
                    print("lllll :\(String(describing: result?.coordinate.latitude))")
                    print("lnggggg :\(String(describing: result?.coordinate.longitude))")
                    print(resultMain?.attributedFullText.string)
      
//                    self.navigationController?.popViewController(animated: true)
//                    if let dic = result?.addressComponents{
//                        print(dic as Any)
//                    self.seletedAddressDelegate.getSeletedAddress(selectedAddress: dic as Any)
//                    }
                    let geoCoder = CLGeocoder()
                    let location = CLLocation(latitude: (result?.coordinate.latitude)!, longitude: (result?.coordinate.longitude)!)
                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

                              var placeMark: CLPlacemark!
                              placeMark = placemarks?[0]
                            self.displayLocationInfo(placemark: placeMark)
                     
                          })
                    
                }
                 else {
                    print("Error : \(error?.localizedDescription ?? "")")
                }
            })
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?)   {

            var locality =  ""
            var postalCode =  ""
            var administrativeArea = ""
            var subAdministrativeArea = ""
            var country = ""
            var sublocality = ""
            var throughfare = ""
            var subThroughfare = ""

            var name = ""

            if let containsPlacemark = placemark {
                //stop updating location to save battery life
                //            locationManager.stopUpdatingLocation()
                name = (containsPlacemark.name != nil) ? containsPlacemark.name! : ""
                locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality! : ""
                postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode! : ""
                administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea! : ""
                country = (containsPlacemark.country != nil) ? containsPlacemark.country! : ""
                sublocality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality! : ""
                throughfare = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare! : ""
                subAdministrativeArea = (containsPlacemark.subAdministrativeArea != nil) ? containsPlacemark.subAdministrativeArea! : ""
                subThroughfare = (containsPlacemark.subThoroughfare != nil) ? containsPlacemark.subThoroughfare! : ""
            }

        let addressDic = NSMutableDictionary.init()
        addressDic.setObject(name, forKey: "name" as NSCopying)
        addressDic.setObject(throughfare, forKey: "throughfare" as NSCopying)
        addressDic.setObject(subThroughfare, forKey: "subThroughfare" as NSCopying)
        addressDic.setObject(locality, forKey: "locality" as NSCopying)
        addressDic.setObject(sublocality, forKey: "sublocality" as NSCopying)
        addressDic.setObject(administrativeArea, forKey: "administrativeArea" as NSCopying)
        addressDic.setObject(subAdministrativeArea, forKey: "subAdministrativeArea" as NSCopying)
        addressDic.setObject(country, forKey: "country" as NSCopying)
        addressDic.setObject(postalCode, forKey: "postalCode" as NSCopying)
   
        self.dismiss(animated: true, completion: nil)
        self.seletedAddressDelegate.getSeletedAddress(selectedAddress: addressDic)
        }
    

}


extension GoogleAddressesResultViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            self.placeAutocomplete(newString)
        return true
    }
}
