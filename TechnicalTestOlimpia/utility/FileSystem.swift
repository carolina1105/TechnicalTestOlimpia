//
//  FileSystem.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit

class FileSystem: NSObject {
    
    private static var sharedInstance: FileSystem?
    
    let temporary: String = "temp_%@"
    
    class var shared: FileSystem {
        guard let shared = self.sharedInstance else {
            let sharedInstance = FileSystem()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return shared
    }
    
    func procject(folder path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            return
        }
        
        let file = [ FileAttributeKey(kCFURLFileProtectionKey as String) : kCFURLFileProtectionCompleteUntilFirstUserAuthentication ]
        do {
            try FileManager.default.setAttributes(file as [FileAttributeKey : Any], ofItemAtPath: path)
        } catch {
            print(error.localizedDescription)
        }
        
        let attributes = [ URLResourceKey(kCFURLIsExcludedFromBackupKey as String) ]
        let url = NSURL(fileURLWithPath: path)
        do {
            try url.resourceValues(forKeys: attributes)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func temporaryDirectory() -> String {
        let directory = String(format: temporary, UUID().uuidString)
        let path = NSTemporaryDirectory().appendingPathComponent(directory)
        _ = self.exists(path: path,
                        with: .complete)
        return path
    }
    
    func temporaryPath(with `extension`: String?) -> String {
        let directory = temporaryDirectory()
        var fileName = UUID().uuidString
        let lenght = `extension`?.count ?? .zero
        if lenght > .zero {
            fileName = fileName.appending(".").appending(`extension` ?? "")
        }
        let path = URL(fileURLWithPath: directory).appendingPathComponent(fileName).path
        return path
    }
    
    func exists(path: String,
                with protectionType: FileProtectionType) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        if exists {
            return self.protect(file: path,
                                with: protectionType)
        } else {
            do {
                try FileManager.default.createDirectory(atPath: path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print(error)
                return false
            }
        }
        return self.protect(file: path,
                            with: protectionType)
    }
    
    func protect(file: String,
                 with protectionType: FileProtectionType) -> Bool {
        if !FileManager.default.fileExists(atPath: file) {
            return false
        }
        
        let protection = [ FileAttributeKey.protectionKey : protectionType ]
        do {
            try FileManager.default.setAttributes(protection, ofItemAtPath: file)
        } catch {
            print(error)
            return false
        }
        
        let url = URL(fileURLWithPath: file)
        do {
            let _ = try url.resourceValues(forKeys: [URLResourceKey.isExcludedFromBackupKey])
        } catch {
            print(error)
            return false
        }
        
        return true
    }
    
    class func destroy() {
        sharedInstance = nil
    }
}
