//
//  ManagerWS.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import Alamofire

fileprivate struct Empty: Codable {
}

fileprivate struct CrytptoDTO: Codable {
    var datacrypt: String
}

fileprivate enum CrytptoError: Swift.Error {
    case unknown
}

class ManagerWS {
    private static let datacrypt: String = "datacrypt"
    static let shared = ManagerWS()
    
    private let fiveHundred: Int = 500
    
    let minCodeSuccess = 200
    let maxCodeSuccess = 299
    let fourHundredTwentyTwoCode = 422
    let empty = ""
    var timeOut: Double = 20    
    
    private let session: Session = {
        var configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 40
        return Session(configuration: configuration)
    }()
    
    private func headers() -> HTTPHeaders {
        return HTTPHeaders([Constant.default.apiAuthKey  : "DEMO-API-KEY"])
    }
    
    private func toError<D: Decodable,
                         F: Decodable>(status: Int,
                                       data: Data?,
                                       completion: @escaping (D?, F?, ErrorDTO?) -> Void) {
        do {
            let error = ErrorDTO(error: "TEXT_ERROR_CONNECTION".localized)
            guard let data = data else {
                completion(nil, nil, error)
                return
            }
            let decoder = JSONDecoder()
            if status == fiveHundred {
                let webError = try decoder.decode(ErrorDTO.self, from: data)
                completion(nil, nil, webError)
            } else {
                let fail = try decoder.decode(F.self, from: data)
                if fail is Empty {
                    completion(nil, nil, error)
                    return
                }
                completion(nil, fail, nil)
            }
        } catch {
            completion(nil, nil, ErrorDTO(error: "TEXT_TITLE_FAIL".localized))
        }
    }
    
    private func toError(status: Int,
                         data: Data?,
                         completion: @escaping (CrytptoDTO?, ErrorDTO?) -> Void) {
        do {
            let error = ErrorDTO(error: "TEXT_ERROR_CONNECTION")
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            if status == fiveHundred {
                let webError = try decoder.decode(ErrorDTO.self, from: data)
                completion(nil, webError)
            } else {
                let fail = try decoder.decode(CrytptoDTO.self, from: data)
                completion(fail, nil)
            }
        } catch {
            completion(nil, ErrorDTO(error: "TEXT_TITLE_FAIL".localized))
        }
    }
    
    func make(url: String,
              success: @escaping (Data) -> Void,
              failure: @escaping (Error) -> Void) {
        session.request(url).response { response in
            guard let data = response.data else {
                failure(response.error!)
                return
            }
            success(data)
        }
    }
    
    func cancel(upload: String) {
        session.session.getTasksWithCompletionHandler { (_, uploadTasks, _) in
            uploadTasks.forEach {
                if $0.currentRequest?.url?.absoluteString == upload {
                    $0.cancel()
                }
            }
        }
    }
    
    
    func cancel(download: String) {
        session.session.getTasksWithCompletionHandler { (_, _, downloadTasks) in
            downloadTasks.forEach {
                if $0.currentRequest?.url?.absoluteString == download {
                    $0.cancel()
                }
            }
        }
    }
    
    func make(url: String,
               method: HTTPMethod,
               parameters: [String : Any]? = nil,
               socketId: String? = nil,
               encrypted: Bool = true,
               success: @escaping (Data?) -> Void,
               failure: @escaping (Data?, Error?) -> Void) {
        let headers = self.headers()
        
        let body = getBody(parameters, encrypted)
        
        self.session.request(url, method: method,
                             parameters: body,
                             encoding: JSONEncoding.default,
                             headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if self.isSuccessCode(statusCode: response.response?.statusCode ?? 0) ||
                        response.response?.statusCode == self.fourHundredTwentyTwoCode {
                        let datastring = NSString(data: response.data!, encoding: String.Encoding.isoLatin1.rawValue)
                        let newData = datastring!.data(using: String.Encoding.utf8.rawValue)
                        success(self.getData(newData, encrypted))
                        return
                    }
                    break
                case .failure(let error):
                    failure(nil, error)
                }
            }
    }
    
    func isSuccessCode(statusCode: NSInteger) -> Bool {
        if statusCode >= minCodeSuccess && statusCode <= maxCodeSuccess {
            return true
        }
        return false
    }
    
    
    func getBody(_ parameters: [String : Any]?,
                 _ encrypted: Bool) -> [String : Any]?  {
        var body: [String : Any]?
        body = parameters
        return body
    }
    
    func getData(_ response: Data?,
                 _ encrypted: Bool) -> Data? {
        var data: Data?
        data = response
        return data
    }
    
}
