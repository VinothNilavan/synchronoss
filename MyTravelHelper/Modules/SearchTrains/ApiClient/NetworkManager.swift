//
//  NetworkManager.swift
//  ProjectNew
//  Created by Vinoth on 04/10/22.
//

import Foundation

public typealias APICompletion<T> = (APIResult<T>) -> Void

class NetworkManager {
    static func getDetails(type: String? = "" , completion: @escaping APICompletion<[String]>) {
        ApiClient.shared.request(ProductIdRouter.productList(type ?? ""), completion: completion)
    }
}
