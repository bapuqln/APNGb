//
//  DragAndDropWebView.swift
//  APNGb
//
//  Created by Stefan Godoroja on 10/27/16.
//  Copyright © 2016 Godoroja Stefan. All rights reserved.
//

import WebKit

protocol DragAndDropImageDelegate {
    func didDropImages(withPaths paths: [String])
}

final class DragAndDropWebView: WebView {
    
    var delegate: DragAndDropImageDelegate?
    
    private var validator: DragAndDropValidator
    private let allowedFileTypes = ["png", "apng"]
    
    required init?(coder: NSCoder) {
        validator = DragAndDropValidator(withAllowedFileTypes: allowedFileTypes)
        super.init(coder: coder)
    }
    
    // MARK: - NSDraggingDestination
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return validator.draggingEntered(sender)
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return validator.draggingUpdated(sender)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let imagesPaths = validator.draggingResult(sender)
        let imageHTML = "<!DOCTYPE html> <head> <style type=\"text/css\"> html { margin:0; padding:0; } body {margin: 0; padding:0;} img {position:absolute; top:0; bottom:0; left:0; right:0; margin:auto; max-width:100%; max-height: 100%;} </style> </head> <body id=\"page\"> <img src=\"file://\(imagesPaths[0])\"> </body> </html>​"
        mainFrame.loadHTMLString(imageHTML, baseURL: nil)
        
        delegate?.didDropImages(withPaths: imagesPaths)
        
        return true
    }
}