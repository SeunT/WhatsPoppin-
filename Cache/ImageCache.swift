//
//  ImageCache.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/5/23.
//

import Foundation
import UIKit

class ImageCache {
  static let shared = ImageCache()

  private let cache = NSCache<NSString, UIImage>()

  private init() {}

  func getImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
    if let image = cache.object(forKey: urlString as NSString) {
      // Image is in cache, return it
      completion(image)
    } else {
      // Image not in cache, download it and add it to the cache
      if let url = URL(string: urlString) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
            print("Error downloading image: \(error)")
            completion(nil)
            return
          }

          if let data = data, let image = UIImage(data: data) {
            self.cache.setObject(image, forKey: urlString as NSString)
            completion(image)
          } else {
            completion(nil)
          }
        }
        task.resume()
      }
    }
  }
}
