//
//  Endpoint+Extensions.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import Foundation

public struct Endpoint {
   public enum Method: String {
       case get = "GET"
       case post = "POST"
       case put = "PUT"
       case delete = "DELETE"
       case path = "PATCH"
   }
   private let host: String
   private let inputPath: String
   public var queries: [String] = []
   
   var headers: [String: String] = [:]
   var body: [String: Any] = [:]
   public let method: Method
   
   var path: String {
       return inputPath + queries.joined()
   }

   public var url: URL {
       let newPath = path.components(separatedBy: " ").joined()
       return URL(string: host + newPath)!
   }
   
   public init(host: String, path: String, method: Method) {
       self.host = host
       self.method = method
       self.inputPath = path
   }
   
   public func addQuery(key: String, value: String) -> Endpoint {
       var new = self
       let queryString = queries.isEmpty ? "?\(key)=\(value)" : "&\(key)=\(value)"
       new.queries.append(queryString)
       return new
   }
   
   public func addHeader(name: String, value: String) -> Endpoint {
       var new = self
       new.headers[name] = value
       return new
   }
   
   public func addBody(name: String, value: [String]) -> Endpoint {
       var new = self
       new.body[name] = value
       return new
   }

   public func addBody(name: String, value: String) -> Endpoint {
       var new = self
       new.body[name] = value
       return new
   }
}
