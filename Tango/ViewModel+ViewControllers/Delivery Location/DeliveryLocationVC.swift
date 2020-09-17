//
//  DeliveryLocationVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import MapKit
protocol DeliveryLocationSaved {
    func getDeliveryLocation(Address : String, addressID : Int)
}
class DeliveryLocationVC: BaseViewController , MKMapViewDelegate{
    
    //properties outlet.
    @IBOutlet weak var tblVw : UITableView!
    var locationManager = CLLocationManager()
   // var delegate : MapViewAddress?
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var addressString : String = ""
    @IBOutlet weak var hostMapView: MKMapView!
    
    var param = AddressSaveParamModel()
    lazy var viewModel: DeliveryLocationAddVM = {
        return DeliveryLocationAddVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initializeViewModel()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        hostMapView.delegate = self
        hostMapView.mapType = MKMapType.standard
        hostMapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        param.type = "Shop"
        let longTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        hostMapView.addGestureRecognizer(longTapGesture)
    }
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {

        hostMapView.removeAnnotations(hostMapView.annotations)
        let location = gestureRecognizer.location(in: hostMapView)
        let coordinate = hostMapView.convert(location, toCoordinateFrom: hostMapView)

        getAddressFromLatLon(pdblLatitude: coordinate.latitude, pdblLongitude: coordinate.longitude)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

                let identifier = "Annotation"
                var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

                if annotationView == nil {

                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true

                    let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                    label1.text = self.addressString //annotation.title!//"Some text1 some text2 some text2 some text2 some text2 some text2 some text2"
                     label1.numberOfLines = 0
                      annotationView!.detailCalloutAccessoryView = label1;

                    let width = NSLayoutConstraint(item: label1, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
                    label1.addConstraint(width)


                    let height = NSLayoutConstraint(item: label1, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 90)
                    label1.addConstraint(height)


                } else {
                    annotationView!.annotation = annotation
                }
                return annotationView
            }
        
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        // Set action to callout view
    //
    //    }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

            // center the mapView on the selected pin
            let region = MKCoordinateRegion(center: view.annotation!.coordinate, span: mapView.region.span)
            mapView.setRegion(region, animated: true)
        }
        
            func loadServiceMapView(lat : Double, long : Double , address : String){
                hostMapView.removeAnnotations(hostMapView.annotations)
                hostMapView.delegate = self
                hostMapView.mapType = MKMapType.standard
                hostMapView.showsUserLocation = true
                
                let CLLCoordType = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
                
                let viewRegion = MKCoordinateRegion(center: CLLCoordType, latitudinalMeters: 50, longitudinalMeters: 50)
                hostMapView.setRegion(viewRegion, animated: false)
                let london = MKPointAnnotation()
                //london.title = address//addressString
                london.coordinate =  CLLCoordType // CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
                hostMapView.addAnnotation(london)
            }
        
        func getAddressFromLatLon(pdblLatitude: Double, pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            
            param.latitude = lat
            param.longitude = lon
            

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                       
                        self.addressString = ""
                        if pm.subLocality != nil {
                            self.addressString = self.addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            self.param.city = pm.thoroughfare
                            self.addressString = self.addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            self.addressString = self.addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            self.addressString = self.addressString + pm.country! + ", "
                             self.param.country = pm.country
                        }
                        if pm.postalCode != nil {
                            self.addressString = self.addressString + pm.postalCode! + " "
                            self.param.pincode = pm.postalCode
                        }
                        
                        self.param.state = pm.administrativeArea
                        
                        print(self.addressString)
                        //self.lblLocationFullAddress.text = self.addressString
                        print(self.addressString)
                        self.tblVw.reloadData()
                        self.param.map_address = self.addressString
                        self.loadServiceMapView(lat: pdblLatitude, long: pdblLongitude, address: self.addressString)
                  }
            })
        }
    
    private func configureUI(){
        //topHeaderSet(vc : self)
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.register(DeliveryLocationCell.nib(), forCellReuseIdentifier: DeliveryLocationCell.identifier)
        tblVw.register(DeliveryDetailsCell.nib(), forCellReuseIdentifier: DeliveryDetailsCell.identifier)
    }
    @IBAction func btnSaveAction(_ sender : UIButton){
        
        viewModel.getAddressSaveResponse(param: param)
    }
    
    func initializeViewModel() {
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self?.viewModel.addressSave.type != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.addressSave.type![0])!, okButtonText: okText, completion: nil)
                }else{
                    if self?.viewModel.addressSave.message != nil {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.addressSave.message)!, okButtonText: okText, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
}

extension DeliveryLocationVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationCell") as! DeliveryLocationCell
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailsCell") as! DeliveryDetailsCell
            Cell.txtVwAddress.delegate = self
            Cell.txtVwAddress.text = self.param.map_address
            Cell.txtVwAddress.textColor = UIColor.lightGray
            Cell.txtFldHouseNo.delegate = self
            Cell.txtFldHouseNo.text = param.building
            Cell.txtFldlandmark.delegate = self
            Cell.txtFldlandmark.text = param.landmark
            Cell.txtFldHouseNo.tag = 1
            Cell.txtFldlandmark.tag = 2
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 0
        }
        return 360
    }
}
extension DeliveryLocationVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Address"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let txtAfterUpdate = textView.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as String
        print("Updated TextField:: \(updateText)")
        param.map_address = updateText
        return true
    }
}
extension DeliveryLocationVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as String
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
        case 1:
            param.building = updateText
        case 2:
            param.landmark = updateText
        default:
            print("default")
        }
        return true
    }
}

class CustomPointAnnotation: MKPointAnnotation {
var pinCustomImageName:String!
}

extension DeliveryLocationVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getAddressFromLatLon(pdblLatitude: locValue.latitude, pdblLongitude: locValue.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
}
