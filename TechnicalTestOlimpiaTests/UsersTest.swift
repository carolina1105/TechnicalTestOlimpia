//
//  UsersTest.swift
//  TechnicalTestOlimpiaTests
//
//  Created by Laddy Diaz Lamus on 17/11/20.
//

import XCTest
@testable import TechnicalTestOlimpia

class UsersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testUsers() {
        //Arrange - expect
        let expectation = self.expectation(description: "user")
        
        let expectedUser = UserModel(id: 1, 
                                     name: "Carolina Díaz", 
                                     identification: "123456", 
                                     address: "Av 2 # 10-56", 
                                     avatar: "test", 
                                     city: "Medellín", 
                                     country: "Colombia", 
                                     cellphone: "12345", 
                                     geolocation: "test")
        
        var usersRepo: UserModel?
        
        //Act
        UserModel.mock { user in
            usersRepo = user
            expectation.fulfill()
        }
        
        //Assert
        waitForExpectations(timeout: 5)
        XCTAssertEqual(expectedUser, usersRepo)
    }
    
    func testGetUserFailure() {
        //Arrange
        let expectation = self.expectation(description: "user failure")
        
        let expectedMessage = "URLSessionTask failed with error: unsupported URL"
        
        var errorMessage: AppError?
        
        //Act
        UserModel.mockError { error in
            errorMessage = error
            expectation.fulfill()
        }
        
        //Assert
        waitForExpectations(timeout: 5)
        XCTAssertEqual(expectedMessage, errorMessage?.rawValue)
    }
    
    func testGetUsers() {
        //Arrange - expect
        let expectation = self.expectation(description: "users list")
        
        var expectedUsersList =  [UserModel(id: 1, 
                                            name: "Carolina Díaz", 
                                            identification: "123456", 
                                            address: "Av 2 # 10-56", 
                                            avatar: "test", 
                                            city: "Medellín", 
                                            country: "Colombia", 
                                            cellphone: "12345", 
                                            geolocation: "test"),
                                  UserModel(id: 1, 
                                            name: "Carolina Díaz", 
                                            identification: "123456", 
                                            address: "Av 2 # 10-56", 
                                            avatar: "test", 
                                            city: "Medellín", 
                                            country: "Colombia", 
                                            cellphone: "12345", 
                                            geolocation: "test"),
                                  UserModel(id: 1, 
                                            name: "Carolina Díaz", 
                                            identification: "123456", 
                                            address: "Av 2 # 10-56", 
                                            avatar: "test", 
                                            city: "Medellín", 
                                            country: "Colombia", 
                                            cellphone: "12345", 
                                            geolocation: "test"),
                                  UserModel(id: 1, 
                                            name: "Carolina Díaz", 
                                            identification: "123456", 
                                            address: "Av 2 # 10-56", 
                                            avatar: "test", 
                                            city: "Medellín", 
                                            country: "Colombia", 
                                            cellphone: "12345", 
                                            geolocation: "test")]
        
        var userListRepo: [UserModel]?
        
        //Act
        UserModel.mockList { users in
            expectedUsersList = users
            expectation.fulfill()
        }
        
        //Assert
        waitForExpectations(timeout: 2)
        XCTAssertEqual(expectedUsersList, userListRepo)
        
    }
    
    func testGetUsersFailure() {
        //Arrange
        let expectation = self.expectation(description: "generation list failure")
        
        let expectedMessage = "URLSessionTask failed with error: unsupported URL"
        
        var errorMessage: AppError?
        
        //Act
        UserModel.mockError { error in
            errorMessage = error
            expectation.fulfill()
        }
        
        //Assert
        waitForExpectations(timeout: 5)
        XCTAssertEqual(expectedMessage, errorMessage?.rawValue)
    }
    
}
