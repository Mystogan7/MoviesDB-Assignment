//
//  Caching.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/21/19.
//

import Foundation

final class Caching {
    
    private let memory = NSCache<NSString, NSData>()
    
    private let diskPath: URL
    
    private let fileManager: FileManager
    
    private let serialQueue = DispatchQueue(label: "Recipes")
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            diskPath = documentDirectory.appendingPathComponent("Recipes")
            try createDirectoryIfNeeded()
        } catch {
            fatalError()
        }
    }
    
    func save(data: Data, key: String, completion: (() -> Void)? = nil) {
        let key = key.MD5
        
        serialQueue.async {
            self.memory.setObject(data as NSData, forKey: key! as NSString)
            do {
                try data.write(to: self.filePath(key: key!))
                completion?()
            } catch {
                print(error)
            }
        }
    }
    
    func load(key: String, completion: @escaping (Data?) -> Void) {
        let key = key.MD5
        
        serialQueue.async {
            if let data = self.memory.object(forKey: key! as NSString) {
                completion(data as Data)
                return
            }
            
            if let data = try? Data(contentsOf: self.filePath(key: key!)) {
                self.memory.setObject(data as NSData, forKey: key! as NSString)
                completion(data)
                return
            }
            
            completion(nil)
        }
    }
    
  
    private func filePath(key: String) -> URL {
        return diskPath.appendingPathComponent(key)
    }
    
    private func createDirectoryIfNeeded() throws {
        if !fileManager.fileExists(atPath: diskPath.path) {
            try fileManager.createDirectory(at: diskPath, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    /// Clear all items in memory and disk cache
    func clear() throws {
        memory.removeAllObjects()
        try fileManager.removeItem(at: diskPath)
        try createDirectoryIfNeeded()
    }
}
