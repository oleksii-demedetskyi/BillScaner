//
//  BillXMLParser.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import Foundation

class BillParserDelegate: NSObject, XMLParserDelegate {
    enum Error: Swift.Error {
        case documentNotFinished
    }
    
    enum Result {
        case error(Error), items([Bill.Item])
    }
    var result: Result = .error(.documentNotFinished)
    
    var items: [Bill.Item] = []
    
    var lastElementName: String?
    var currentElementID: String?
    
    var currentElementTitle: String?
    var currentElementPrice: Float?
    var currentElementQuantity: Int?
    
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        // Filer out root element
        guard elementName != "bill" else { return }
        
        if currentElementID == nil {
            currentElementID = elementName;
            return
        }
        
        lastElementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch lastElementName {
        case "name"?: currentElementTitle = string
        case "quantity"?: currentElementQuantity = Int(string)
        case "price"?: currentElementPrice = Float(string)
        default: break }
        
        lastElementName = nil
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?)
    {
        guard elementName == currentElementID else { return }
     
        currentElementID = nil
        
        guard let name = currentElementTitle else { return parsingFailed(parser) }
        guard let price = currentElementPrice else { return parsingFailed(parser) }
        guard let quantity = currentElementQuantity else { return parsingFailed(parser) }
        guard let item = try? Bill.Item(title: name, count: quantity, cost: price) else {
            return parsingFailed(parser)
        }
        
        items.append(item)
    }
    
    func parsingFailed(_ parser: XMLParser) {
        parser.abortParsing()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        result = .items(items)
    }
}

extension Bill {
    init(xml: Data) throws {
        let parser = XMLParser(data: xml)
        
        let delegate = BillParserDelegate()
        parser.delegate = delegate
        parser.parse()
        
        switch delegate.result {
        case .error(let error): throw error
        case .items(let items): self.items = items }
    }
}
