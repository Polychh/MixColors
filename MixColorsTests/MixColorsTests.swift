//
//  MixColorsTests.swift
//  MixColorsTests
//
//  Created by Polina on 09.02.2024.
//

import XCTest
import Combine
@testable import MixColors
final class MixColorsTests: XCTestCase {
    
    var sut: ViewModelProtocol!
    var serv: LocaleServiceProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ColorViewModel(localeServ: LocaleService())
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        sut = nil
        serv = nil
        cancellables = nil
        try super.tearDownWithError()
        
    }
    
    func testMixedColors() throws {
        //Given
        let color1 = UIColor.red
        let color2 = UIColor.blue
        let mixedColor = UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)
        var mixedResult: UIColor
        //When
        mixedResult = sut.mixedColors(color1: color1, color2: color2)
        //Then
        XCTAssertEqual(mixedResult, mixedColor)
    }
    
    func testUpdateColor() throws{
        //Given
        let colorIndex = 1
        let expectedColor = UIColor.green
        //When
        sut.updateColor1(colorIndex: colorIndex)
        //Then
        XCTAssertEqual(sut.color1, expectedColor)
    }
    
    func testLangChoose() throws{
        //Given
        let expectation = XCTestExpectation(description: "en")
        let segIndex = 1
        let expectedResult = Language.english.rawValue
        sut.languagePublisher
            .dropFirst(2)
            .sink { lang in
                XCTAssertEqual(expectedResult, lang.rawValue)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //When
        sut.choseSegment(segIndex: segIndex)
        //Then
        wait(for: [expectation], timeout: 1)
    }
    
    func testSaveInitialLang() {
        //Given
        let expectedResult = Language.russian.rawValue
        //When
        sut.saveInitialLang()
        let setLang = UserDefaults.standard.string(forKey: "Localizable")
        //Then
        XCTAssertEqual(setLang, expectedResult)
    }
}

