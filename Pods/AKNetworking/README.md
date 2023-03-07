# Networking     
 
![LOGO](Documentation/component_logo.png)


![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/v/AKNetworking)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/l/AKNetworking)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/p/AKNetworking)
[![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/i/AKNetworking)](./LICENSE)


# Description

**Networking** provides high level abstractions for making server requests. It's built on top of NSURLSession, providing a robust and lightweight construction. 

Features: 

* Network abstractions for HTTP endpoints
* SSL certificate whitelisting for trusted servers
* Request/Response logging
* Local Server
* JSON parser for easily consuming JSON data
* UIImageView extension for image cache/loading 
* AKReachability for monitoring internet connection availability
* Cache Management and Cache Policy
* Client Certificate
* Multipart file upload

# Installation

#### CocoaPods:

[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Once you ready with CocoaPods, use this code in your `Podfile`:

```
source 'git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/cocoapod-specs.git'

platform :ios, '12.0'
use_frameworks!

pod 'AKNetworking'
```

#### Carthage:

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using Carthage](http://www.mokacoding.com/blog/setting-up-testing-libraries-with-carthage-xcode7/)

Once you ready with Carthage, use this code in your `Cartfile`:

```
git 'git@INMBZP4112.in.dst.ibm.com:assemblykit/framework_aknetworking.git' ~> 2.4.1
```

# Requirements

Version | Language | Xcode | iOS
------- | -------- | ----- | ---
1.5.0 | Swift 5.3 | 12 | 12.0

# Programming Guide

## DataSourceManager 

### Overview

DataSourceManager provides high-level network abstractions as well as seamless switching between remote HTTP endpoints and local data. 

### Usage

#### Configuration

DataSourceManager supports 2 modes of operation:

1. Local data
2. Remote HTTP endpoints

##### Local 

By default, DataSourceManager starts in remote mode, but you can switch to local mode with the following:

```

import AKNetworking

DataSourceManager.localMode = true

//A baseURLString should be set with http or https
//if a baseURL is not set, each request should be made with the pattern
//http://somehost 
DataSourceManager.baseURLString = "http://localhost"

```

When running in local mode, you must supply a `LocalServerDelegate` which is responsible for supplying mock responses to your network requests. Networking provides a `LocalServer` which adopts the `LocalServerDelegate` protocol and can be used to register route handlers. See the section below on `Local Server` for more information.

```

// setup mock server
let server = LocalServer()

// wire up the mock server with request handlers
server.get("/user/:id", handler: { (request, parameters) -> Response in
    
    // build the mock response
    return Response(string: "foo")
})

// setup local mode with base paths
DataSourceManager.baseURLString = "http://httpbin.org"
DataSourceManager.localMode = true
DataSourceManager.localServerDelegate = server

```

You can check if running in local data mode:

```

if DataSourceManager.localMode {
    // Running in local mode
}

```

#### Making a Request

```

import AKNetworking

DataSourceManager.baseURLString = "http://httpbin.org"

...

DataSourceManager.request(.GET, "http://httpbin.org/ip")
DataSourceManager.request(NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!))

```

##### Path-based Requests

You can configure DataSourceManager with a base URL string for use with path-based requests. 

```

DataSourceManager.baseURLString = "http://httpbin.org"

...

let _ = DataSourceManager.request(.GET, "/authenticate")

```

##### Headers

``` 

let headers = ["Authorization": "abc123"]

DataSourceManager.request(.GET, "http://httpbin.org", parameters: nil, encoding: .json, headers: headers)

```

##### Logging

Networking supports request and response logging to console and file, by default logging is disabled.

Disable Logging

```
AKRequestLogging.instance.shouldLogRequestsToConsole = false
AKRequestLogging.instance.shouldLogRequestsToFile = false

```

Enable Logging

```
AKRequestLogging.instance.shouldLogRequestsToConsole = true
AKRequestLogging.instance.shouldLogRequestsToFile = true

```

If logging (console and file) enabled, Networking print logs in console and save into a file 'AKLoggingFile' under Document folder (document/Logs/). 


##### Cache Management and Cache Policy


Networking framework cache the responses to URL requests by mapping NSURLRequest objects to NSCachedURLResponse objects.

#### Cache memory capacity
To set cache memory capacity

```
CacheManager.instance.memoryCapacity = 512 * 1024 * 1024
```

#### Clear cache db 
To clear cache db

```
CacheManager.instance.clearCache()
```

#### Cache control policy
Supported RequestCacheControl options 
 
 1. Public 
 2. Private 
 3. NoCache 
 4. NoStore
 5. MaxAgeNonExpired
 6. MaxAgeExpired

To set cache control policy in request header

```
self.headers["Cache-Control"] = cacheControl.rawValue
```

You can configure the cache policy for each request. For more information see also [NSURLRequestCachePolicy](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/#//apple_ref/c/tdef/NSURLRequestCachePolicy).

```

DataSourceManager.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad

let _ = DataSourceManager.request(.GET, "http://httpbin.org")

```

#### Building Local Responses

You can build local responses using the chainable `Response` class:

```

let _ = Response(data: NSData(contentsOfFile: "somePath")!).withStatusCode(404)
Response(filename: "local_JSON_filename", ofType: "json").withHeaders(["foo": "bar", "bar": "foo"])
Response(json: ["id": 123, "name": "Jeremy Koch", "kids": ["Ciaran", "Shia"]])

```

#### Handling the Response

```

let _ = DataSourceManager.request(.GET, "/flights").response { (request, response, data, error) in
    // Do stuff to handle the response
}

```

The `response` method takes a closure that is executed asynchronously, with a `NSData` object, upon completion of the request.  The closure is dispatched to the main queue. 

DataSourceManager also supports serializing the response to a `String`, `JSON`, or `UIImage` object (see sections below).

##### Response as String

```

let _ = DataSourceManager.request(.GET, "/flights").responseString { (request, response, string, error) in
    // Do stuff to handle the response
}

```

##### Response as JSON

```

let _ = DataSourceManager.request(.GET, "/flights").responseJSON { (request, response, json, error) in
    // Do stuff to handle the response
}

```

##### Response as Image

```

let _ = DataSourceManager.request(.GET, "/photo").responseImage { (request, response, image, error) in
    // Do stuff to handle the response
}

```

#### Validation 

By default, all completed requests are considered successful.  To enable validation of the response, a chainable `validate` method is available which causes the error parameter to be set accordingly in the completion handler.  For example:

##### Automatic Validation

```
let validator = ResponseValidator(headers: ["Content-Type" : "application/json"])

let _ = DataSourceManager.request(.GET, "/headers")
            .validate()
            .responseJSON { (request, response, json, error) in
                print("hello")
}

```

##### Manual Validation

You can also validate a **String** type or **JSON** type, see the example with **String** below 

```
let validator = ResponseValidator(string: "httpbin")

let _ = DataSourceManager.request(.GET, "/get")
	.validate(validator)
	.responseString { (request, response, string, error) in

}

```

Now see an example with **JSON**:

```
let json: JSON = ["headers" : ["Host" : "httpbin.org"] as AnyObject, "url" : "http://httpbin.org/get" as AnyObject]
        let validator = ResponseValidator(json: json)
        
let _ = DataSourceManager.request(.GET, "/get")
    .validate(validator)
    .responseJSON { (request, response, json, error) in
}

```

### Extensions

#### UIImageView

Provides support for loading remote images asynchronously from a URL. The image view is updated once the request is finished. 

The following methods are added to UIImageView:

``` 

extension UIImageView {
    public func setImageWithURL(_ url: URL)
    public func setImageWithURL(_ url: URL, placeholderImage: UIImage?)
    public func setImageWithURLRequest(_ urlRequest: URLRequest, placeholderImage: UIImage?, success: ((_: URLRequest?, _: HTTPURLResponse?, _: UIImage?) -> Void)?, failure: ((_: URLRequest?, _: HTTPURLResponse?, _: NSError) -> Void)?)
    public func cancelImageRequest()
}

```

For example:

```

let url = NSURL(string: "http://example.com/image.png")

// automatic response handling updates image view upon completion
cell.imageView.setImageWithURL(url!)
cell.imageView.setImageWithURL(url!, placeholderImage: placeholderImage)

// manual response handling
weak var weakCell = cell // don't retain the cell since it may scroll off screen and be reused
imageView.setImageWithURLRequest(NSURLRequest(URL:app.imageURL), placeholderImage: UIImage(), success: { (request, response, image) -> Void in
    weakCell?.imageView.image = image
}, failure: nil)

```

### Sample 

Here is how a request is executed from a view controller:

```

// load employee
DataSourceRequest.request(.GET, "/employee").validate().responseJSON { (_, _, data, error) -> Void in
    if let error = error {
        self.simpleAlertwithTitle("A network error has occurred. Please try again.")
    } else {
        context.employee = Response.employeeFromJSON(data)
        self.securedRootViewController.updateWithSecureContext(context)
        self.flipFromViewController(self.authorizationRootViewController, toController: self.securedRootViewController, options: UIViewAnimationOptions.TransitionCrossDissolve)                
    }
}

```

### Advanced

#### Session Manager

The `DataSourceManager` class is simply a proxy to a shared `SessionManager` instance.  The following two statements are equivalent:

```
let _ = DataSourceManager.request(.GET, "http://example.org")
```

```
let sessionManager = SessionManager.sharedInstance
sessionManager.request(.GET, "http://example.org")
```

##### Creating a SessionManager

```
let sessionManager = SessionManager.sharedInstance
```

##### Changing Timeout Session

You can change the timeout session for request and resource. 
**Important:** you need to set timeout values before to start session.

```
DataSourceManager.timeoutSessionIntervalForRequest = 30 // Default value is 60 seconds.
DataSourceManager.timeoutSessionIntervalForResource = 24*60*2 // Default value is 7 days.

let _ = DataSourceManager.request(.GET, "http://httpbin.org/ip")
let _ = DataSourceManager.request(NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!))

```

#### Request

The `DataSourceManager.request(...)` method returns a `Request` object.  The `Request` object exposes the chainable `validate()` and `response()` methods which also returns `Self`. A `Request` wraps a NSURLSessionTask, so it can be cancelled, suspended or resumed:

* `suspend()`: Temporarily suspends a task.
* `cancel()`: Cancels the task.
* `resume()`: Resumes the task, if it is suspended.


#### Adding Additional HTTP Header to All Requests

```

let deviceModel = UIDevice.current.model
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
DataSourceManager.addHeaderWithName("Device-Model", value:deviceModel)
DataSourceManager.addHeaderWithName("App-Version", value:appVersion)
DataSourceManager.addHeaderWithName("Accept-Language", value:"en-US")

```

#### Global Request Timeout

The default NSURLRequest timeout is 60 seconds. Although it's not recommended, you may need to globally change that value. In general, it is best to leave the default timeout and instead make your network requests cancelable through the UI, then you can invoke the `request.cancel()` method.

```

DataSourceManager.timeoutInterval = 120  // 120 seconds

```

#### Simulated Local Response Delay

By default, `DataSourceManager` delays 0.5 seconds when returning a local response to simulate network latency.  You may want to adjust this delay during unit or UI testing.

```

DataSourceManager.localResponseDelayInterval = 2.0   // 2 seconds

```

#### Response Handling with Alternate Queue

By default, the response completion handler is dispatched on the main queue. You can specify an alternate queue using the chainable `completionQueue(queue: dispatch_queue_t)` function.

```

let queue = DispatchQueue.global(qos: .background)

let _ = DataSourceManager.request(Request.Flights).completionQueue(queue).response { (request, response, data, error) in
    // Do stuff to handle the response
}

```


## Local Server

### Overview

Local Server provides a mechanism for registering local handlers for network requests through `DataSourceManager`. Instead of being routed across the wire, a request can be handled locally with a simulated server response.

### Routing

A route is a combination of a HTTP request method (GET, POST, and so on), a URI, and a handler for the endpoint. It takes the following structure `server.METHOD(path: String, handler: (request, parameters) -> Response))`, where server is an instance of `LocalServer`, METHOD is an HTTP request method, path is a path on the server, and handler is the function executed when the route is matched.

#### Simple Routes

```

// setup mock server
let server = LocalServer()

// wire up the mock server with request handlers
server.get("/profile", handler: { (request, parameters) -> Response in

    // build the mock response
    return Response(string: "foo")
})

```

#### Parameterized Routes

Route parameters along with query and fragment parameters are automatically parsed and available in the `parameters` parameter of the route handling closure.

A request `GET "http://example.org/user/123?foo=bar#bam=pow"` will be matched to the following route:

```

// wire up the mock server with request handlers
server.get("/user/:id", handler: { (request, parameters) -> Response in
    
    // ensure the parameters was parsed
    XCTAssertEqual(parameters["id"]!, "123", "id should equal 123")
    XCTAssertEqual(parameters["foo"]!, "bar", "foo should equal bar")
    XCTAssertEqual(parameters["bam"]!, "pow", "bam should equal pow")
    
    // build the mock response
    return Response(string: "foo")
})

```

#### HTTP Body Parsing

For POST requests, parsing the HTTP body is possible by accessing the `HTTPBody` property of the `request` parameter.

```
server.post("/data", handler: { (request, parameters) -> Response in
    // inspect the body
    JSON(data: request.HTTPBody!)
    
    // build the mock response
    return Response(json: ["bam": "pow"])
})
```

#### Wildcards

Wildcards can be used to match routes:

``` 

server.get("/user/:id/*", handler: { (request, parameters) -> Response in
    // create a new JSON response
    return Response(json: ["id": parameters["id"]!])
})

```

#### Hostname

By default, the hostname is ignored unless it is explicitly registered with the route:

```

server.host("example.org").get("/*", handler: { (request, parameters) -> Response in
    return Response().withStatusCode(401)
})

```


#### Namespace 

When a set of endpoints all share a common base path, a namespace can be used to simplify defining path handlers.

For example, for the following endpoints: 

```
/user/login
/user/logoff

```

The namespace can be configured as follows:

```

let server = LocalServer()

let users = server.namespace("/tools")
users.get("/hammers", handler: { (_, _) in return Response() })
users.get("/saws", handler: { (_, _) in return Response() })

```


## JSON

### Overview

JSON provides a parsing abstraction for easily consuming JSON data. JSON is a wrapper around data that simplifies parsing value (eg. string, number, boolean, date, URL)

### Usage

#### Initialization

With NSData: 

``` 

import AKNetworking

JSON(data: data)

```

With JSON from file:

``` 

import AKNetworking

JSON(filename: "somefile", ofType: "json")

```

With any object:

```

import AKNetworking

JSON(object)

```

#### Creating JSON

The JSON framework supports creating JSON objects using Swift Literal Convertibles.

```

let json: JSON = ["id": 123  as AnyObject, "name": "Jeremy Koch"  as AnyObject, "kids": ["Ciaran", "Shia"]  as AnyObject]

```

``` 

# update existing JSON using subscripts
json["id"] = "123"
json["children"][1] = ["name": "Shia" as AnyObject]

```

#### Parsing

Assuming the following input JSON: 

```
{
    "name": {
        "first": "Jon",
        "last": "Wiita"
    },
    "phoneNumber": "555-555-1234",
    "numberOfAccounts": 12,
    "activeSince": "2014-09-12T01:30:00Z",
    "paidMember": true,
    "photoURL": "http://example.org/photo",
    "children": [{ 
        name: "Molly Wiita",
        age: 15
    }, {
        name: "Jimmy Wiita",
        age: 12
    }]    
}

```

##### Overview

All parsing methods have a `func type()` and `func typeValue()` variant.  The `func type()` variant, for example `func string()`, returns an optional `String?` based on if the property exists. The `func typeValue()` variant, for example `func stringValue()`, returns a non-optional `String` which is empty if the property does not exist. 

##### String

```

let value = json["missingProperty"].stringValue // assigned ""

let value = json["phoneNumber"].stringValue     // assigned "555-555-1234"

```

##### Number

```

let value = json["missingProperty"].numberValue  // assigned 0
let value = json["missingProperty"].intValue     // assigned 0
let value = json["missingProperty"].floatValue   // assigned 0.0
let value = json["missingProperty"].doubleValue  // assigned 0.0

let value = json["numberOfAccounts"].intValue    // assigned 12

```

##### Boolean

```

let value = json["missingProperty"].boolValue  // assigned false

let value = json["paidMember"].boolValue       // assigned true

```

##### URL

```

let value = json["photoURL"].url       // assigned optional NSURL(string: "http://example.org/photo")

```

##### Date

```

let value = json["missingProperty"].dateValue     // assigned new NSDate() - current time

let value = json["activeSince"].dateValue         // assigned NSDate set to Sept 12, 2009

```

Here is the full list of date parsing methods:

```

var date: NSDate? { get }
var dateValue: NSDate { get }

public func dateFromFormat(_ format: String, timezone: TimeZone = TimeZone(identifier: "timezone")!) -> Date?
public func dateValueFromFormat(_ format: String, timezone: TimeZone = TimeZone(identifier: "")!) -> Date

var dateNormalizedToGMT: Date? { get }
var dateValueNormalizedToGMT: Date { get }

func dateNormalizedToGMTFromFormat(_ format: String) -> Date?
func dateValueNormalizedToGMTFromFormat(_ format: String) -> Date

```

##### Array

```

let array = json["missingProperty"].arrayValue                     // assigned empty array
let array = json["children"].arrayValue                            // assigned array of JSON wrapped objects

```

##### Iteration

```

for item in json["children"] {
    let value = item["name"].stringValue                    // assigned "Molly Wiita" then "Jimmy Wiita"
}

```

##### Subscripts

```

let value = json["children"][0]["name"].stringValue         // assigned "Molly Wiita"
let value = json["children"][1]["name"].stringValue         // assigned "Jimmy Wiita"

```

##### Optionals

```

if let value = json["phoneNumber"].string {
    // Valid property
}

if let value = json["numberOfAccounts"].int {
    // Valid property
}

if let value = json["paidMember"].boolean {
    // Valid property
}

if let value = json["activeSince"].date {
    // Valid property
}

```
## Multipart file upload

### Overview
Networking supports multipart file upload request along with json object. Networking supports text, xlsx, pptx, pdf, jpg, png, mp4, mp3 etc file types.

### Usage

How to create file upload payload -  


```
let payload = [MultipartConstants.FileName : "fileName.extension", MultipartConstants.FileData : fileData, MultipartConstants.JSONData : JSONObject]
          
```

How to create/make multipart upload request - 

```
DataSourceManager.multipartUploadRequest(urlString: "/upload", parameters: [MultipartConstants.Content : payload], headers: nil, uploadClosure: { 
					error, status in
     					if(error != "") {
                   		//Handle error response
                		} else {
                   		 DispatchQueue.main.async {
                    	//Handle success 
                    	//Upload progress status
                    	//Update UI here   
                		}
               })
```

# Communication

Contact the developer's team:
[assemblykit@us.ibm.com](mailto:assemblykit@us.ibm.com)
