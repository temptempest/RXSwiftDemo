//
//  Constant.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import Foundation
public enum Constants {
    enum Strings {
        static let newsApp = "News App"
        static let noData = "No data"
    }
    enum News {
        private static let apiKey = ""
        static let newsEndpoint = Endpoint(host: "https://newsapi.org", path: "/v2/top-headlines", method: .get)
            .addQuery(key: "country", value: "us")
            .addQuery(key: "apiKey", value: apiKey)
    }
    enum Weather {
        private static let apiKey = ""
        static func weatherEndpoint(cityName: String) -> Endpoint {
            return Endpoint(host: "https://api.openweathermap.org", path: "/data/2.5/weather", method: .get)
                .addQuery(key: "q", value: cityName)
                .addQuery(key: "units", value: "metric")
                .addQuery(key: "APPID", value: apiKey)
        }
    }
}

public enum Observers {
    static let articlesListObserver = URLRequest.load(resource: ArticlesList.all)
}
