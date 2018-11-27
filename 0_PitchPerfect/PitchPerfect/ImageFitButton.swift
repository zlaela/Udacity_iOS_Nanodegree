/**
  FitButton.swift
  PitchPerfect
 
  Simple extension to UIButton that scales button images

  Created by lmohamed on 11/25/18.
  Copyright © 2018 tribl. All rights reserved.
**/

import UIKit

class ImageFitButton: UIButton {
    
    override func layoutSubviews() {
        self.imageView?.contentMode = .scaleAspectFit
        super.layoutSubviews()
    }
}
