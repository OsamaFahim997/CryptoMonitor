//
//  LocalFileManager.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import Foundation
import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              let data = image.pngData()
        else { return }
        
        // save image to path
        do {
            try data.write(to: url)
        } catch (let error) {
            print("Error in saving file to local manager \(error.localizedDescription) \(image)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch (let error) {
                print("Error creating directory \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let url = getURLForFolder(folderName: folderName) else { return nil }
        
        return url.appendingPathComponent(imageName + ".png")
    }
    
}
