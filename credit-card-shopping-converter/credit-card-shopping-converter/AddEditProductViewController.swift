//
//  ProdutoViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 27/08/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit
import CoreData

class AddEditProductViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var ivImagemProduto: UIImageView!
    @IBOutlet weak var tfPurchaseState: UITextField!
    
    var estado: [Estados] = []
    var statesManager = StatesManager.shared
    var purchasePickerList = [Estados]()
    var selectedPicker: String?
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadStates()
        createPurchaseStatePicker()
        createToolBar()
        loadPurchaseStatePicker()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        
        product.name = tfName.text
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadStates() {
        statesManager.loadStates(with: context)
        let _ : NSFetchRequest<Estados> = Estados.fetchRequest()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(state: Estados?){
        let alert = UIAlertController(title: "Adicionar estado", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nome do estado"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Imposto"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { action in
            
            let stateName = alert.textFields![0].text!
            let tributeValue = alert.textFields![1].text!
            
            let state = state ?? Estados(context: self.context)
            state.nome = stateName
            state.imposto = Double(tributeValue) ?? 0.0
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

        }))
        self.present(alert, animated: true)

    }
    
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
    }
    
    @IBAction func addImagemProduto(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createDayPicker(){
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        tfPurchaseState.inputView = dayPicker
    }
    
    func createPurchaseStatePicker(){
        
        let purchaseStatePicker = UIPickerView()
        purchaseStatePicker.delegate = self
        
        tfPurchaseState.inputView = purchaseStatePicker
    }
    
    func loadPurchaseStatePicker(){
        statesManager.loadStates(with: context)
        let fetchRequest : NSFetchRequest<Estados> = Estados.fetchRequest()
        
//        fetchRequest.propertiesToFetch = ["nome"]
        
        purchasePickerList = try! context.fetch(fetchRequest)
        
        print( purchasePickerList )
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissKeyboard) )
        
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        tfPurchaseState.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }

}

extension AddEditProductViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return purchasePickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Estados? {
        return purchasePickerList[row]
    }

//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedPicker = purchasePickerList[row]
//        tfPurchaseState.text = selectedPicker
//    }
    
}


extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            ivImagemProduto.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

