//
//  ItemStoreCreateItemViewController.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation

class ItemStoreCreateItemViewController: UIViewController
{
    @IBOutlet weak var selectedImageImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    var server: ItemStoreServer?
    var image: UIImage? = nil          //Selected image from user
    
    
    @IBAction func didClickAddImageButton(sender: UIButton)
    {
        pickPhoto()
    }
    
    
    @IBAction func didClickCreateItemButton(sender: UIButton)
    {
        //Validate that we have both name and image else we show an alert
        guard let image = image else { showNotEnoughDataError(); return }
        guard let name = nameField.text where name.characters.count != 0 else { showNotEnoughDataError(); return }
        
        createItem(image, name: name)
    }
    
    
    func pickPhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func createItem(image: UIImage, name: String)
    {
        server?.createItemWithName(name, image: image, success: { (item: Item) in
            print("createItem success")
            self.navigationController?.popViewControllerAnimated(true)
        }, failure: { (error: NSError) in
            print("createItem error = \(error)")
        })
    }
    
    
    func showNotEnoughDataError()
    {
        let alert = UIAlertView(title: "Error", message: "Please type your name and select an image", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}


extension ItemStoreCreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        self.image = image
        selectedImageImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}