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
    @IBOutlet weak var ivButton: UIButton!
    @IBOutlet weak var tfPurchaseState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var creditCard: UISwitch!
    @IBOutlet weak var lbAddEdit: UIButton!
    @IBOutlet weak var ivAddImage: UIImageView!
    
    var estado: [States] = []
    var purchasePickerList = [States]()
    var product: Product!
    var statesManager = StatesManager.shared
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        self.tfPrice.keyboardType = .decimalPad
        self.hideKeyboardWhenTappedAround()
        
        if product != nil {
            title = "Alterar produto"
            ivAddImage.image = nil
            ivButton.setTitle(nil, for: .normal)
            tfName.text = product.name
            ivImagemProduto.image = product.cover as? UIImage
            tfPurchaseState.text = product.state?.name
            tfPrice.text = String(describing: product.price)

            let credit = product.credit_card ? true : false
            creditCard.setOn(credit, animated:true)

            lbAddEdit.setTitle("Alterar", for: .normal)

        }else{
            title = "Adicionar produto"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        
        title = "Alterar produto"
        if product == nil {
            product = Product(context: context)
            title = "Adicionar produto"
        }
        
        if (tfName.text ?? "").isEmpty {
            requireAlert(mensagem: "Nome do produto é obrigatório")
            return
        }else{
            product.name = tfName.text
        }
        
        // validar imagem
        if let image = ivImagemProduto.image {
            product.cover = image
        }else{
            requireAlert(mensagem: "Imagem do produto é obrigatório")
            return
        }

        if !tfPurchaseState.text!.isEmpty {
            let state = statesManager.states[pickerView.selectedRow(inComponent: 0)]
            product.state = state
        }else{
            requireAlert(mensagem: "Estado da compra é obrigatório")
            return
        }

        if let price = tfPrice.text {
            if tfPrice.text!.isEmpty {
                requireAlert(mensagem: "Valor do produto é obrigatório")
                return
            }else {
                product.price = Double( price )!
            }
        }        
        
        product.credit_card = creditCard.isOn

        do{
            try self.context.save()
            navigationController?.popViewController(animated: true)

        }catch{
            print(error.localizedDescription)
        }
    }
    
    @objc func cancel(){
        tfPurchaseState.resignFirstResponder()
    }
    
    @objc func done(){
        tfPurchaseState.text = statesManager.states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statesManager.loadStates(with: context)
        
        //Se não houver estado cadastrado, o mesmo sera desabilitado, pois ocorre um bug ao abrir uma lista vazia e clicar em done
        if statesManager.states.count > 0 {
            tfPurchaseState.isUserInteractionEnabled = true
        }else{
            tfPurchaseState.text = nil
            tfPurchaseState.isUserInteractionEnabled = false
        }
    }
    
    func requireAlert(mensagem: String){

        let alert = UIAlertController(title: mensagem, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true)
        
        self.context.rollback()

    }

    func decimal(with string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    @IBAction func addImagemProduto(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)

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

//    func createPurchaseStatePicker(){
//
//        let purchaseStatePicker = UIPickerView()
//        purchaseStatePicker.delegate = self
//        tfPurchaseState.inputView = purchaseStatePicker
////        tfPurchaseState.isUserInteractionEnabled = false
//    }

    func createToolBar(){

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [btCancel, btFlexibleSpace, btDone]
        tfPurchaseState.inputView = pickerView
        tfPurchaseState.inputAccessoryView = toolBar
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddEditProductViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesManager.states.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = statesManager.states[row]
        return state.name
    }

}

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            ivAddImage.image = nil
            self.ivImagemProduto.image = image
            self.ivButton.setTitle(nil, for: .normal)
            
        }
        
        dismiss(animated: true, completion: nil)
    }

}

