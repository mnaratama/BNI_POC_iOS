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

import Foundation

// **********************************************************************************************************
//
// MARK: - Constants -
//
// **********************************************************************************************************

let defaultHostName = "AKNetworking.DefaultHost"

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

public typealias RouteHandler = (_: URLRequest, _: [String: String]) -> Response

// **********************************************************************************************************
//
// MARK: - Class -
//
// **********************************************************************************************************

/**
 LocalServer Class provides a easy way to test your requests with
 mocked data.
 */
public class LocalServer: LocalServerDelegate {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    var host: Host
    var serverHosts: [String: LocalServer] = [:]
    
    // **************************************************
    // MARK: - Constructors
    // **************************************************
    
    public init() {
        self.host = Host(defaultHostName)
    }
    
    // MARK: - Private initializer
    
    init(host: String) {
        self.host = Host(host)
    }
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    // **************************************************
    // MARK: - Request matching delegate
    // **************************************************
    /**
     Tells the local server what to response he should give to this
     NSURLRequest.
     
     - parameter urlRequest: a Request to be mocked by the LocalServer.
     
     - returns: servers Response.
     */
    public func responseForURLRequest(_ urlRequest: URLRequest) -> Response {
        
        var server = self
        let key = keyForURL(urlRequest.url)
        if let namedServer = serverHosts[key] {
            server = namedServer
        }
        
        if let urlRequestMethod = urlRequest.httpMethod,
            let method = AKNetworking.Method(rawValue: urlRequestMethod),
            let router = server.host.routes[method],
            let response = router.route(urlRequest) {
            // return the response from the matched handler
            return response
        } else {
            // default handler returns 404
            return Response().withStatusCode(404)
        }
        
    }
    
    // **************************************************
    // MARK: - Host methods
    // **************************************************
    
    public func host(_ host: String) -> LocalServer {
        return self.host(host, port: nil)
    }
    
    public func host(_ host: String, port: Int?) -> LocalServer {
        if self.host.host != defaultHostName {
            fatalError("You cannot call \"host\" multiple times")
        }
        
        let key = keyForHost(host, withPort: port)
        if let server = self.serverHosts[key] {
            return server
        } else {
            let server = LocalServer(host: host)
            self.serverHosts[key] = server
            return server
        }
        
    }
    
    // **************************************************
    // MARK: - Namespace methods
    // **************************************************
    
    public func namespace(_ namespace: String) -> LocalServer {
        self.host.namespace = URL(string: namespace)?.path ?? ""
        return self
    }
    
    // **************************************************
    // MARK: - Routing methods
    // **************************************************
    
    public func get(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.GET, url: url, handler: handler)
    }
    
    public func post(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.POST, url: url, handler: handler)
    }
    
    public func delete(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.DELETE, url: url, handler: handler)
    }
    
    public func head(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.HEAD, url: url, handler: handler)
    }
    
    public func put(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.PUT, url: url, handler: handler)
    }
    
    public func patch(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.PATCH, url: url, handler: handler)
    }
    
    public func trace(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.TRACE, url: url, handler: handler)
    }
    
    public func options(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.OPTIONS, url: url, handler: handler)
    }
    
    public func connect(_ url: String, handler: @escaping RouteHandler) {
        self.host.addRoute(.CONNECT, url: url, handler: handler)
    }
    
    // **************************************************
    // MARK: - Override Public Methods
    // **************************************************
    
}

// **************************************************
// MARK: - Internal router
// **************************************************
class Host {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    var host: String
    var namespace: String = ""
    
    init(_ host: String) {
        self.host = host
    }
    
    var routes: [AKNetworking.Method: Router] = {
        var routes: [AKNetworking.Method: Router] = [:]
        routes[.GET] = Router()
        routes[.POST] = Router()
        routes[.DELETE] = Router()
        routes[.HEAD] = Router()
        routes[.PUT] = Router()
        routes[.PATCH] = Router()
        routes[.TRACE] = Router()
        routes[.OPTIONS] = Router()
        routes[.CONNECT] = Router()
        return routes
    }()
    
    // **************************************************
    // MARK: - Constructors
    // **************************************************
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    func addRoute(_ method: AKNetworking.Method, url: String, handler: @escaping RouteHandler) {
        routes[method]?.addRoute(namespace + url, handler: handler)
    }
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    // **************************************************
    // MARK: - Override Public Methods
    // **************************************************
}

class Router {
    
    var routes: [Route] = []
    
    // MARK: - Routing methods
    
    func route(_ urlRequest: URLRequest) -> Response? {
        
        let url = urlRequest.url!
        let queryParams = url.query?.urlParameters() ?? [String: String]()
        let fragmentParams = url.fragment?.urlParameters() ?? [String: String]()
        let pathComponents = url.pathComponents.filter {
            $0 != "/"
        }
        
        for route in routes {
            let result = route.matchesRoute(url, requestPathComponents: pathComponents)
            if result.matches {
                var allParameters = [String: String]()
                allParameters += queryParams
                allParameters += fragmentParams
                allParameters += result.parameters
                return route.handler(urlRequest, allParameters)
            }
            
        }
        
        return nil
    }
    
    func addRoute(_ pattern: String, handler: @escaping RouteHandler) {
        routes.append(Route(pattern: pattern, handler: handler))
    }
    
    func removeRoute(_ pattern: String) {
        routes = routes.filter {
            $0.pattern != pattern
        }
        
    }
    
    func removeAllRoutes() {
        routes.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Internal route class
    
    struct Route {
        var pattern: String
        var handler: RouteHandler
        
        func matchesRoute(_ url: URL, requestPathComponents: [String]) -> (matches: Bool, parameters: [String: String]) {
            
            let urlFromPattern = URL(string: pattern)!
            let routePathComponents = urlFromPattern.pathComponents.filter({
                $0 != "/"
            })
            
            if routePathComponents.count == requestPathComponents.count || self.pattern.range(of: "*") != nil {
                var componentIndex = 0
                var matches = true
                var variables = [String: String]()
                
                for routePathComponent in routePathComponents {
                    var component: String?
                    if componentIndex < requestPathComponents.count {
                        component = requestPathComponents[componentIndex]
                    } else if routePathComponent == "*" {
                        component = requestPathComponents.last
                    }
                    
                    if let component = component {
                        if routePathComponent.hasPrefix(":") {
        
                            var variableKey = routePathComponent
                            variableKey.remove(at: variableKey.startIndex)
                            
                            if let variableValue = component.urlDecodedString() {
                                if variableKey.count > 0 && variableValue.count > 0 {
                                    variables[variableKey] = variableValue
                                }
                                
                            }
                            
                        } else if routePathComponent == "*" {
                            matches = true
                            break
                        } else if routePathComponent != component {
                            matches = false
                            break
                        }
                        
                    }
                    
                    componentIndex += 1
                }
                
                return (matches, variables)
            }
            
            return (false, [:])
        }
        
    }
    
}

// **************************************************
// MARK: - String extensions for URL utilities
// **************************************************
extension String {
    func urlDecodedString() -> String? {
        if DataSourceManager.disableReplacingOccurOfPlusChar {
            return self.removingPercentEncoding ?? self
        } else {
            return self.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? self
        }
        
    }
    
    func urlParameters() -> [String: String] {
        guard let string = urlDecodedString() else {
            return [:]
        }
        
        var parameters = [String: String]()
        for keyValueString in string.components(separatedBy: "&") {
            let pair = keyValueString.components(separatedBy: "=")
            let value = pair.count == 2 ? pair[1] : ""
            parameters[pair[0]] = value
        }
        
        return parameters
    }
    
}
