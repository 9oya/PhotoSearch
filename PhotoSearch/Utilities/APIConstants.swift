//
//  APIConstants.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/27.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
    case appToken = "App-Token"
}

enum AcceptType: String {
    case anyMIMEgtype = "*/*"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
    case xwwwFormUrlencoded = "application/x-www-form-urlencoded; charset=utf-8"
}

enum HTTPStatus: Int {
  case ok = 200

  case badRequest = 400
  case notAuthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404

  case internalServerError = 500
}
