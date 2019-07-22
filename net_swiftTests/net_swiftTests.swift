//
//  net_swiftTests.swift
//  net_swiftTests
//
//  Created by apple on 22/07/2019.
//  Copyright © 2019 wumian. All rights reserved.
//

import XCTest
@testable import net_swift

class net_swiftTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = XCTestExpectation.init(description: "hi ApiTest")
        dataCenter.request(WMService.preLogin(userName: "传入参数"), model: WMPreLogin.self) { (isSuccess, res, error) in
            // 1、XCTAssertTrue：如果!isSuccess，是true就通过，则如果想看API的正常返回结构，打开👇
            //            XCTAssertTrue(!isSuccess, String.init(NSString.init(format: "sssssssss %zd-%zd-%zd", res?.isRegister ?? "", res?.commonEquipment ?? "",!isSuccess)))
            
            // 2、XCTAssertTrue：如果isSuccess，是true就通过，否则不通过。打印出错误信息
            XCTAssertTrue(isSuccess, String.init(NSString.init(format: "API ERROR%@", error ?? "")))
            // 3、XCTAssertNil：如果error，是Nil就通过，否则不通过。打印出错误信息
            XCTAssertNil(error, String.init(NSString.init(format: "API ERROR%@", error ?? "")))
            expect.fulfill()
        }
        // 等待10秒，进行异步请求
        self.wait(for: [expect], timeout: 10)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
