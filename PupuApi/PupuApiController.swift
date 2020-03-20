//
//  ApiController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Alamofire

typealias JSONObject = [String: Any]
typealias ListIdentifier = (username: String, slug: String)

protocol PupuAPIProtocol {
    static func banners() -> Observable<[JSONObject]>;
}

struct PupuApi: PupuAPIProtocol {
    
    private static let isLocal = true
    
    // MARK: - API Addresses
    fileprivate enum Address: String {
      case banners = "Mall/Banners?position_type=-1&"
      case baseData = "Common/BaseDataVersionService?zip=350206&places_ver=0&categories_ver=0&place_id=33308975-6f0c-4792-8459-8a5ff7d91d74&"

      case homePage = "Mall/HomePage?not_tag=40&"

      private var baseURL: String {
          return "https://c.pupuapi.com/"
      }

      private var suffix: String {
          return "token=random&store_id=35b95ee7-4501-49b0-8a04-44c052e54bd2"
      }
      var url: URL {
        return URL(string: baseURL.appending(rawValue).appending(suffix))!
      }
    }

    // MARK: - API errors
    enum Errors: Error {
      case requestFailed
    }

    // MARK: - API Endpoint Requests
    
    static func banners() -> Observable<[JSONObject]> {
        
        var response: Observable<JSONObject>!
        
        if PupuApi.isLocal {
            response = loadLocal("banner")
        } else {
           response  = request(PupuApi.Address.banners)
        }

        return response
          .map { result in
            guard let users = result["list"] as? [JSONObject] else {return []}
            return users
        }
    }
    
    static func baseData() -> Observable<JSONObject> {
        var response: Observable<JSONObject>!
        
        if PupuApi.isLocal {
            response = loadLocal("baseData")
        } else {
           response  = request(PupuApi.Address.baseData)
        }
        
        return response
          .map { result in
            guard let baseJsonData = result["t"] as? JSONObject else {return [:]}
            return baseJsonData
        }
    }
    
    static func homePage() -> Observable<[JSONObject]> {
        var response: Observable<JSONObject>!
        
        if PupuApi.isLocal {
            response = loadLocal("homePage")
        } else {
           response  = request(PupuApi.Address.homePage)
        }
        
        return response
          .map { result in
            guard let baseJsonData = result["list"] as? [JSONObject] else {return []}
            return baseJsonData
        }
    }


    // MARK: - generic request to send an SLRequest
    
    static private func loadLocal<T: Any>(_ localName:String ) -> Observable<T> {
        return Observable.create { observer in
            if let cachedFileURL = Bundle.main.url(forResource: localName, withExtension: "json"),
                let data = try? Data(contentsOf: cachedFileURL), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? T, let result:T = json {
                observer.onNext(result)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    static private func request<T: Any>(_ address: Address, parameters: [String: String] = [:]) -> Observable<T> {
      return Observable.create { observer in

        let request = Alamofire.request(address.url,
                                        method: .get,
                                        parameters: Parameters(),
                                        encoding: URLEncoding.httpBody,
                                        headers: [
                                            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/7.0.11(0x17000b21) NetType/WIFI Language/zh_CN",
                                            "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNGM2MGQyZS1hMWJjLTQ0MmEtOTUxNS05NzgyMWJkNTBiMTMiLCJnaXZlbl9uYW1lIjoi5ZC06L-q546uIiwic3ViIjoiIiwiaXNfbm90X25vdmljZSI6IjEiLCJleHAiOjE1ODYxNDIwMDAsImlzcyI6Imh0dHBzOi8vdWMucHVwdWFwaS5jb20iLCJhdWQiOiJodHRwczovL3VjLnB1cHVhcGkuY29tIn0.nDq1jHS3A-UIiXtJlHScu-3QggJh1E9sjZs5jLF472Y",
                                            "pp-userid":"d4c60d2e-a1bc-442a-9515-97821bd50b13",
                                            "pp-version":"2019052000",
                                        ])

        request.responseJSON { response in
          guard response.error == nil, let data = response.data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as?T, let result:T = json else {
            observer.onError(Errors.requestFailed)
            return
          }
          
          observer.onNext(result)
          observer.onCompleted()
        }

        return Disposables.create {
          request.cancel()
        }
      }
    }
}

extension String {
    var safeFileNameRepresentation: String {
        return replacingOccurrences(of: "?", with: "-")
                .replacingOccurrences(of: "&", with: "-")
                .replacingOccurrences(of: "=", with: "-")
    }
}

extension URL {
    var safeLocalRepresentation: URL {
        return URL(string: absoluteString.safeFileNameRepresentation)!
    }
}
