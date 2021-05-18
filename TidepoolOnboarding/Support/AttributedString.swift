//
//  AttributedString.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/10/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation

struct AttributedString {
    enum Attribute {
        case bold
        case italic
    }

    struct Fragment {
        let string: String
        let attributes: Set<Attribute>?

        init(_ string: String, attributes: Set<Attribute>? = nil) {
            self.string = string
            self.attributes = attributes?.isEmpty == false ? attributes : nil
        }
    }

    let fragments: [Fragment]

    init(_ string: String) {
        self.fragments = [Fragment(string)]
    }

    init(attributed string: String) {
        self.fragments = Parser().parse(string) ?? [Fragment(string)]
    }

    var string: String { fragments.reduce(String(), { $0 + $1.string }) }

    private class Parser: NSObject, XMLParserDelegate {
        private var fragments: [Fragment] = []
        private var attributes: [Attribute] = []
        private var error: Error?

        func parse(_ string: String) -> [Fragment]? {
            guard let data = "<normal>\(string)</normal>".data(using: .utf8) else {
                return nil
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            guard parser.parse() else {
                return nil
            }

            return !fragments.isEmpty ? fragments : nil
        }

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
            switch elementName {
            case "b":
                attributes.append(.bold)
            case "em", "i":
                attributes.append(.italic)
            default:
                break
            }
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            switch elementName {
            case "b", "em", "i":
                _ = attributes.popLast()
            default:
                break
            }

        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            fragments.append(Fragment(string, attributes: Set<Attribute>(attributes)))
        }
    }
}

extension AttributedString {
    private init(_ other: Self, applying attribute: Attribute) {
        self.fragments = other.fragments.map { Fragment($0, applying: attribute) }
    }

    func bold() -> Self { Self(self, applying: .bold) }

    func italic() -> Self { Self(self, applying: .italic) }
}

fileprivate extension AttributedString.Fragment {
    init(_ other: Self, applying attribute: AttributedString.Attribute) {
        var attributes = other.attributes ?? []
        attributes.insert(attribute)

        self.string = other.string
        self.attributes = attributes
    }
}
