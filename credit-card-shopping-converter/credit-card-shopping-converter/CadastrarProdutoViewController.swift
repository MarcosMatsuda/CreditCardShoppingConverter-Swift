//
//  ProdutoViewController.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 27/08/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//

import UIKit

class CadastrarProdutoViewController: UIViewController {
    
    var estadosArray = [Estado]()

    @IBOutlet weak var ivImagemProduto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEstado(_ sender: Any) {
        let alert = UIAlertController(title: "Adicionar estado", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nome do estado"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Imposto"
        })
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { action in
            
//            if let nome = alert.textFields![0].text {
//                let nome = Estado(nome: "foo", imposto: 1.5)
//            }
            
//            if let imposto = alert.textFields![1].text {
//                let y = Estado(nome: "foo2", imposto: 2.4)
//            }
            
//            estadosArray.append(nome)
//            println(estadosArray)
            
        }))
        self.present(alert, animated: true)
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

}

extension CadastrarProdutoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
