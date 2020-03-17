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
    
    // MARK: - API Addresses
    fileprivate enum Address: String {
      case banners = "Mall/Banners?position_type=-1&"

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
        let response: Observable<JSONObject> = request(PupuApi.Address.banners)

        return response
          .map { result in
            guard let users = result["list"] as? [JSONObject] else {return []}
            return users
        }
    }


    // MARK: - generic request to send an SLRequest
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
