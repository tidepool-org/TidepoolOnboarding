//
//  AttributedStringTests.swift
//  TidepoolOnboardingTests
//
//  Created by Darin Krauss on 5/11/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
@testable import TidepoolOnboarding

class AttributedStringTests: XCTestCase {
    func testInitializer() {
        let attributedString = AttributedString("This is a test")
        XCTAssertEqual(attributedString.fragments.count, 1)
        XCTAssertEqual(attributedString.fragments[0].string, "This is a test")
        XCTAssertNil(attributedString.fragments[0].attributes)
    }

    func testAttributedInitializerWithPlainString() {
        let attributedString = AttributedString(attributed: "This is a test")
        XCTAssertEqual(attributedString.fragments.count, 1)
        XCTAssertEqual(attributedString.fragments[0].string, "This is a test")
        XCTAssertNil(attributedString.fragments[0].attributes)
    }

    func testAttributedInitializerWithUnparsableString() {
        let attributedString = AttributedString(attributed: "This is an <unparseable> test")
        XCTAssertEqual(attributedString.fragments.count, 1)
        XCTAssertEqual(attributedString.fragments[0].string, "This is an <unparseable> test")
        XCTAssertNil(attributedString.fragments[0].attributes)
    }

    func testAttributedInitializerWithBoldString() {
        let attributedString = AttributedString(attributed: "This is <b>bold</b> test")
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "bold")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold])
        XCTAssertEqual(attributedString.fragments[2].string, " test")
        XCTAssertNil(attributedString.fragments[2].attributes)
    }

    func testAttributedInitializerWithEmphasisString() {
        let attributedString = AttributedString(attributed: "This is <em>italic</em> test")
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "italic")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.italic])
        XCTAssertEqual(attributedString.fragments[2].string, " test")
        XCTAssertNil(attributedString.fragments[2].attributes)
    }

    func testAttributedInitializerWithItalicString() {
        let attributedString = AttributedString(attributed: "This is <i>italic</i> test")
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "italic")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.italic])
        XCTAssertEqual(attributedString.fragments[2].string, " test")
        XCTAssertNil(attributedString.fragments[2].attributes)
    }

    func testAttributedInitializerWithBoldAndEmphasisString() {
        let attributedString = AttributedString(attributed: "This is <b><em>bold and italic</em></b> test")
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "bold and italic")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold, .italic])
        XCTAssertEqual(attributedString.fragments[2].string, " test")
        XCTAssertNil(attributedString.fragments[2].attributes)
    }

    func testAttributedInitializerWithBoldAndItalicString() {
        let attributedString = AttributedString(attributed: "This is <b><i>bold and italic</i></b> test")
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "bold and italic")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold, .italic])
        XCTAssertEqual(attributedString.fragments[2].string, " test")
        XCTAssertNil(attributedString.fragments[2].attributes)
    }

    func testAttributedInitializerWithComplexString() {
        let attributedString = AttributedString(attributed: "<b><b/><em/></b>This is <b>bold</b>, <i>italic</i>, and <b><em><b><i>bold and italic</i></b></em></b> test<em/>")
        XCTAssertEqual(attributedString.fragments.count, 7)
        XCTAssertEqual(attributedString.fragments[0].string, "This is ")
        XCTAssertNil(attributedString.fragments[0].attributes)
        XCTAssertEqual(attributedString.fragments[1].string, "bold")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold])
        XCTAssertEqual(attributedString.fragments[2].string, ", ")
        XCTAssertNil(attributedString.fragments[2].attributes)
        XCTAssertEqual(attributedString.fragments[3].string, "italic")
        XCTAssertEqual(attributedString.fragments[3].attributes, [.italic])
        XCTAssertEqual(attributedString.fragments[4].string, ", and ")
        XCTAssertNil(attributedString.fragments[4].attributes)
        XCTAssertEqual(attributedString.fragments[5].string, "bold and italic")
        XCTAssertEqual(attributedString.fragments[5].attributes, [.bold, .italic])
        XCTAssertEqual(attributedString.fragments[6].string, " test")
        XCTAssertNil(attributedString.fragments[6].attributes)
    }

    func testBoldModifier() {
        let attributedString = AttributedString(attributed: "normal<b>bold</b><em>italic</em>").bold()
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "normal")
        XCTAssertEqual(attributedString.fragments[0].attributes, [.bold])
        XCTAssertEqual(attributedString.fragments[1].string, "bold")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold])
        XCTAssertEqual(attributedString.fragments[2].string, "italic")
        XCTAssertEqual(attributedString.fragments[2].attributes, [.bold, .italic])
    }

    func testItalicModifier() {
        let attributedString = AttributedString(attributed: "normal<b>bold</b><em>italic</em>").italic()
        XCTAssertEqual(attributedString.fragments.count, 3)
        XCTAssertEqual(attributedString.fragments[0].string, "normal")
        XCTAssertEqual(attributedString.fragments[0].attributes, [.italic])
        XCTAssertEqual(attributedString.fragments[1].string, "bold")
        XCTAssertEqual(attributedString.fragments[1].attributes, [.bold, .italic])
        XCTAssertEqual(attributedString.fragments[2].string, "italic")
        XCTAssertEqual(attributedString.fragments[2].attributes, [.italic])
    }
}

class AttributedStringFragmentTests: XCTestCase {
    func testInitializerWithoutAttributes() {
        let fragment = AttributedString.Fragment("This is a test")
        XCTAssertEqual(fragment.string, "This is a test")
        XCTAssertNil(fragment.attributes)
    }

    func testInitializerWithEmptyAttributes() {
        let fragment = AttributedString.Fragment("This is a test", attributes: [])
        XCTAssertEqual(fragment.string, "This is a test")
        XCTAssertNil(fragment.attributes)
    }

    func testInitializerWithNonEmptyAttributes() {
        let fragment = AttributedString.Fragment("This is a test", attributes: [.bold, .italic])
        XCTAssertEqual(fragment.string, "This is a test")
        XCTAssertEqual(fragment.attributes, [.bold, .italic])
    }
}
