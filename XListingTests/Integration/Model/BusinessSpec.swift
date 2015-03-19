//
//  BusinessSpec.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Quick
import Nimble
import XListing

class BusinessSpec: QuickSpec {
    override func spec() {
        
        beforeSuite {
            ParseClient.registerSubclasses()
            ParseClient.initializeClient()
        }
        
        afterSuite {
            
        }
        
        describe("Save") {
            var business: BusinessEntity!
            
            beforeEach {
                business = BusinessEntity()
                
                var location = LocationEntity()
                location.address = "3289 Alberta st."
                location.city = "Vancouver"
                location.country = "CA"
                location.state = "BC"
                
                business.nameEnglish = "test business 2"
                business.isClaimed = true
                business.isClosed = false
                business.imageUrl = "placeholder"
                business.url = "placeholder"
                business.mobileUrl = "placeholder"
                business.phone = "6049872738"
                business.location = location
            }
            
            afterEach {
                var r = business.delete()
            }
            
            it("should save to Parse correctly") {
                waitUntil(timeout: 3) { done in
                    business.saveInBackgroundWithBlock({(success: Bool , error: NSError!) -> Void in
                        expect(success).to(beTrue())
                        done()
                    })
                }
                
                let query = BusinessEntity.query()
                query.whereKey("objectId", equalTo: business.objectId)
                query.includeKey("location")
                
                waitUntil(timeout: 3) { done in
                    query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) -> Void in
                        expect(error).to(beNil())
                        expect(objects.count).to(equal(1))
                        
                        let obj = objects.first as BusinessEntity
                        
                        expect(obj.nameEnglish!).to(equal(business.nameEnglish!))
                        expect(obj.isClaimed).to(equal(business.isClaimed))
                        expect(obj.isClosed).to(equal(business.isClosed))
                        expect(obj.imageUrl).to(equal(business.imageUrl))
                        expect(obj.url).to(equal(business.url))
                        expect(obj.mobileUrl).to(equal(business.mobileUrl))
                        expect(obj.phone).to(equal(business.phone))
                        expect((obj.location.address)).to(equal((business.location.address)))
                        expect((obj.location.city)).to(equal((business.location.city)))
                        expect((obj.location.country)).to(equal((business.location.country)))
                        expect((obj.location.state)).to(equal((business.location.state)))
                        
                        done()
                    })
                }
            }
        }
    }
}
