/*
 * IBM iOS Accelerators component
 * Licensed Materials - Property of IBM
 * Copyright (C) 2017 IBM Corp. All Rights Reserved.
 * 6949 - XXX
 *
 * IMPORTANT:  This IBM software is supplied to you by IBM
 * Corp. ("IBM") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit

// **********************************************************************************************************
//
// MARK: - Constants -
//
// **********************************************************************************************************

private let AKNetworkingLofFolder = "Logs"
private let AKNetworkingLogFileName = "AKLoggingFile"
private let AKLogURL = ""
private let AKLogRequest   = "============================ REQUEST ============================="
private let AKLogResponse  = "=========================== RESPONSE ============================="
private let AKLogSeparator = "=================================================================="

private let AKNetworkingMaxLogFileSize: Double = 50000000

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

// **********************************************************************************************************
//
// MARK: - Class -
//
// **********************************************************************************************************

public class AKRequestLogging {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    /**
     Variable that exposes the singleton from AKRequestLogging,
     this var should be used to access public methods and properties
     */
    public static let instance = AKRequestLogging()
    
    private var logString = ""
    
    private var dataManagerPath: String {
        let searchDirectory = FileManager.SearchPathDirectory.documentationDirectory
        let domainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let fileSystem = NSSearchPathForDirectoriesInDomains(searchDirectory, domainMask, true)
        
        var path = fileSystem[0]
        path += "/\(AKNetworkingLofFolder)"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
            
        }
        
        return path
        
    }
    
    /**
     Controls if requests made with DataSourceManager should
     be logged to a file
     */
    public var shouldLogRequestsToFile = false
    
    /**
     Controls if requests made with DataSourceManager should
     be printed to the console
     */
    public var shouldLogRequestsToConsole = false
    
    // **************************************************
    // MARK: - Constructors
    // **************************************************
    
    private init() {
        self.logString = ""
    }
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    private func attributesOfLogFile() -> [FileAttributeKey: Any]? {
        let fileManager = FileManager.default
        let filePath = self.pathForLog()
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: filePath) else {
            return nil
        }
        
        return attributes
    }
    
    private func saveStringToFile(withPath path: String, andString string: String) {
        let data = string.data(using: String.Encoding.utf8)
        ((try? data?.write(to: URL(fileURLWithPath: path), options: [])) as ()??)
    }
    
    private func appendStringToLogFile(_ str: String) {
        
        let filePath = self.pathForLog()
        let fileManager = FileManager.default
        let dataToWrite = str.data(using: String.Encoding.utf8)
        
        if !fileManager.fileExists(atPath: filePath) {
            self.saveStringToFile(withPath: filePath, andString: "")
        }
        
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            return
        }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(dataToWrite!)
        fileHandle.closeFile()
    }
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    func pathForLog() -> String {
        let path = self.dataManagerPath + "/\(AKNetworkingLogFileName)"
        return path
    }
    
    /**
     Deletes the whole log file
     */
    public func deleteLogFile() {
        let fileManager = FileManager.default
        let filePath = self.pathForLog()
        
        if fileManager.fileExists(atPath: filePath) {
             _ = try? fileManager.removeItem(atPath: filePath)
        }
        
    }
    
    /**
     Appends a string to the current string from this class
     
     - parameter str: string to be appended to the internal buffer
     */
    public func appendString(_ str: String) {
        self.logString += "\n\(str)"
    }
    
    /**
     Sets the internal string with the one supplied
     
     - parameter str: string the should be used as the internal buffer
     */
    public func setString(_ str: String) {
        self.logString = str
    }
    
    /**
     * Saves the internal string to a file in the disk
     */
    public func saveLogFile() {
        if shouldLogRequestsToFile {
            _ = self.attributesOfLogFile()
            self.appendStringToLogFile("\n\(self.logString)")
        }
        
        if shouldLogRequestsToConsole {
            print("\(self.logString)")
        }
        
        self.logString = ""
    }
    
    /**
     Saves a string to the log and resets the internal
     string
     
     - parameter str: The string that should be appended to the log file
     */
    public func saveLogString(_ str: String) {
        self.setString(str)
        self.saveLogFile()
    }
    
    // **************************************************
    // MARK: - Override Public Methods
    // **************************************************
    
}

// **************************************************
// MARK: - Request and Response Logging Extension
// **************************************************
extension AKRequestLogging {
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    private func getURLStringForPrinting(_ urlFromRequest: URL?) -> String? {
        var urlString: String? 
        
        if let url = urlFromRequest {
            urlString = url.description
        }
        
        return urlString
    }
    
    private func getHTTPHeadersStringForPrinting(_ headersFromRequest: [String: String]?) -> String? {
        var httpHeadersString: String?
        
        if let headers = headersFromRequest {
            if headers.keys.count > 0 {
                httpHeadersString = "{\n"
                
                for key in headers.keys {
                    if let value = headers[key] {
                        httpHeadersString?.append("    \"\(key)\": \"\(value)\"\n")
                    } else {
                        httpHeadersString?.append("    \"\(key)\": \"null\"\n")
                    }
                    
                }
                
                httpHeadersString?.append("}\n")
            }
            
        }
        
        return httpHeadersString
    }
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    internal func saveRequestLogString(_ request: Request) {
        
        if shouldLogRequestsToFile || shouldLogRequestsToConsole {
            var logString = "\(AKLogRequest)\n"
            
            if let httpMethod = request.request?.httpMethod {
                logString.append("method: \(httpMethod)\n")
            }
            
            if let url = self.getURLStringForPrinting(request.request?.url) {
                logString.append("url: \(url)\n")
            }
            
            if let httpHeaders = self.getHTTPHeadersStringForPrinting(request.request?.allHTTPHeaderFields) {
                logString.append("headers:\(httpHeaders)\n")
            }
            
            if let httpBody = request.request?.httpBody {
                if let bodyString = String(data: httpBody, encoding: String.Encoding.utf8) {
                    logString.append("body: \(bodyString)\n")
                } else {
                    logString.append("body: (binary data) with \(httpBody.count) bytes\n")
                }
                
            }
            
            logString.append("\(AKLogSeparator)\n")
            
            if DataSourceManager.sharedInstance.shouldLog {
                self.saveLogString(logString)
            }
        }
        
    }
    
    internal func saveResponseLogString(_ request: Request, response: HTTPURLResponse, responseData: Data?) {
        if shouldLogRequestsToFile || shouldLogRequestsToConsole {
            var logString = "\(AKLogResponse)\n"
            
            if let httpMethod = request.request?.httpMethod {
                logString.append("method: \(httpMethod)\n")
            }
            
            if let url = self.getURLStringForPrinting(request.request?.url) {
                logString.append("url: \(url)\n")
            }
            
            let httpHeaders = response.allHeaderFields
            var headers = [String: String]()
            for (key, value) in httpHeaders {
                headers[(key as? String)!] = value as? String
            }
            
            let headersString = self.getHTTPHeadersStringForPrinting(headers)
            logString.append("headers: \(String(describing: headersString))")
            
            if let httpBody = responseData {
                if httpBody.count > 0 {
                    if let bodyString = String(data: httpBody, encoding: String.Encoding.utf8) {
                        logString.append("body: \(bodyString)\n")
                    } else {
                        logString.append("body: (binary data) with \(httpBody.count) bytes\n")
                    }
                    
                }
                
            }
            
            logString.append("\(AKLogSeparator)\n")
            
            if DataSourceManager.sharedInstance.shouldLog {
                self.saveLogString(logString)
            }
        }
        
    }
    
}

// **************************************************
// MARK: - Log Retrieve Extension
// **************************************************
extension AKRequestLogging {
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    /**
     Method for getting the log file as a String
     
     - returns: A string with the contents of the log file
     */
    public func getLogFileString() -> String {
        var logString = ""
        
        let logPath = self.pathForLog()
        if let data = try? Data(contentsOf: URL(fileURLWithPath: logPath)),
            let stringFromData = String(data: data, encoding: String.Encoding.utf8) {
            logString.append(stringFromData)
        }
        
        return logString
    }
    
    /**
     Method for getting the log file as a NSData
     
     - returns: A NSData that represents the log file
     */
    public func getLogAsNSData() -> Data {
        let logPath = self.pathForLog()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: logPath)) else {
            return Data()
        }
        
        return data
    }
    
    /**
     Method for printing the log file to the console
     */
    public func printLogFileString() {
        let logString = self.getLogFileString()
        
        print("\(logString)")
    }
    
}
