//  HLURLImageView.swift

/*
 The MIT License (MIT)
 
 Copyright (c) 2018 takayuki kanai.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

class HLURLImageView : UIImageView {
    
    // public member
    
    var timeout: TimeInterval = 10
    var indicatorDefaultWidth: CGFloat = 20.0
    let indicator = UIActivityIndicatorView()
    
    // private menber
    
    private static let imageCache = NSCache<AnyObject, AnyObject>()
    
    // public method
    
    /// loadImage
    /// Load and display images from the server.
    /// - loadImage: String of image address on server
    /// - noImageName: Image file character string at acquisition failure
    public func loadImage(urlString: String, noImageName: String? = nil) {
        
        let url = URL(string: urlString)
        if let imageFromCache = HLURLImageView.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        startIndicator()
        
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideIndicator()
                
                if error != nil {
                    if let noImageName = noImageName {
                        self.image = UIImage(named: noImageName)
                    }
                    print("Error: \(String(describing: error))")
                    return
                }
                
                let imageToCache = UIImage(data:data!)
                self.image = imageToCache
                HLURLImageView.imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
            }.resume()
    }

    // private method
    
    /// startIndicator
    /// Start animation of indicator.
    private func startIndicator() {
        indicator.style = .gray
        indicator.frame = CGRect(x: frame.size.width / 2 - indicatorDefaultWidth / 2, y: frame.size.height / 2 - indicatorDefaultWidth / 2, width: indicatorDefaultWidth, height: indicatorDefaultWidth)
        addSubview(indicator)
        indicator.startAnimating()
    }
    
    /// hideIndicator
    /// Finish the animation of the indicator.
    private func hideIndicator() {
        
        indicator.stopAnimating()
    }
}
