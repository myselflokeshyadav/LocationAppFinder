//
//  FTNoteMarkerView.swift
//  Ardhi
//
//  Created by vlad gorbenko on 1/9/16.
//  Copyright © 2016 Solutions 4 Mobility. All rights reserved.
//

import UIKit

protocol FTMarkerViewDelegate : NSObjectProtocol {
    func didTapDeleteMarker(_ view: UIView)
}

class FTNoteMarkerView: UIView {
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var deleteButton: UIButton?

    weak var delegate: FTMarkerViewDelegate?
    
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.textView?.textColor = UIColor.white
    }

   
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textView = self.textView {
            var exclusionPaths : Array<UIBezierPath> = []
            if let text = textView.text, text.isEmpty == false {
                if let frame = self.deleteButton?.frame {
                    let bezierPath = UIBezierPath(rect: frame)
                    exclusionPaths.append(bezierPath)
                }
            }
            textView.textContainer.exclusionPaths = exclusionPaths
        }
    }
    
    //MARK: - Setup
    
     func setup(withItem item: Any!) {
        
        if let note = item as? Place {
            self.textView?.text = note.description
        }
        self.textView?.textColor = UIColor.white
 
    }
    
    //MARK: - User interaction
    
    @IBAction func remove(_ sender: AnyObject?) {
        self.delegate?.didTapDeleteMarker(self)
    }
}
