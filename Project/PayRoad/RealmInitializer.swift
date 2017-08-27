//
//  AppInitial.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 17..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import Foundation

import RealmSwift
import CoreLocation

class RealmInitializer {

    private static let realm = try! Realm()
    
    static func initializeCategories() {
        
        let resultsCategory = realm.objects(Category.self)
        
        if resultsCategory.count == 0 {
            
            var categories = [Category]()
            
            let category1 = Category()
            category1.id = "category-food"
            category1.name = "식비"
            category1.assetName = "Category_Food"
            categories.append(category1)
            
            let category2 = Category()
            category2.id = "category-shopping"
            category2.name = "쇼핑"
            category2.assetName = "Category_Shopping"
            categories.append(category2)
            
            let category3 = Category()
            category3.id = "category-tour"
            category3.name = "관광"
            category3.assetName = "Category_Tour"
            categories.append(category3)
            
            let category4 = Category()
            category4.id = "category-transport"
            category4.name = "교통"
            category4.assetName = "Category_Transport"
            categories.append(category4)
            
            let category5 = Category()
            category5.id = "category-lodge"
            category5.name = "숙박"
            category5.assetName = "Category_Lodge"
            categories.append(category5)
            
            let category6 = Category()
            category6.id = "category-etc"
            category6.name = "기타"
            category6.assetName = "Category_Etc"
            categories.append(category6)
            
            for category in categories {
                try? realm.write {
                    realm.add(category)
                }
            }
        }
    }
    
    // For DEMO
    static func addSampleTravelData() {
        
        let categories = realm.objects(Category.self)
        
        let travel = Travel()
        travel.name = "리퓰이랑 유럽여행"
        
        let startDateInRegion = DateInRegion()
        startDateInRegion.date = Date(timeIntervalSince1970: 1503657360)
        travel.startDateInRegion = startDateInRegion
        
        let endDateInRegion = DateInRegion()
        endDateInRegion.date = Date(timeIntervalSince1970: 1505081400)
        travel.endDateInRegion = endDateInRegion
        
        let currencyCodes: [String] = ["KRW", "EUR", "GBP", "CHF", "CZK"]
        let currencyRates: [Double] = [1.0, 1335.2, 1440.83, 1167.6, 51.23]
        let budgets: [Double] = [100000, 500, 400, 650, 2000]
        
        for (index, code) in currencyCodes.enumerated() {
            let currency = Currency()
            currency.code = code
            currency.id = travel.id + "-" + code
            currency.rate = currencyRates[index]
            currency.budget = budgets[index]
            travel.currencies.append(currency)
        }
        
        let transactionNames: [String] = ["파리 나비고 교통권", "제너레이터 호스텔", "season에서의 브런치", "루브르 박물관 입장료와 오디오 가이드 대여비", "파리의 평화다방", "샹젤리제 거리 쇼핑", "바토무슈 유람선", "에펠탑 야경과 맥주", "몽파르나스 타워 전망대", "몽쥬약국 쇼핑", "파리 > 스위스 인터라켄"]
        let transactionAmounts: [Double] = [22.15, 31, 28.5, 20, 68, 38, 13.5, 6, 17, 46, 100.4]
        let transactionIsCashes: [Bool] = [true, true, true, true, false, true, true, true, true, false, false]
        let transactionContents: [String] = [
            "교통권을 구매함으로써 일주일간 나는 자유의 몸이 되었다",
            "여기 숙소 너무 좋다.",
            "파리에서의 브런치",
            "루브르 박물관에 왔다. 한국어 오디오 가이드를 빌리고 천천히 돌아다니면서 구경했다. 여기서 모나리자를 처음 봤는데 조그만한 모나리자 앞에 많은 사람들이 몰려있는게 기억에 남는다",
            "TripAdvisor에서 파리 맛집으로 유명해서 와본 곳. 분위기 끝내주고 음식도 맛있었는데 너무 비쌌다 😢",
            "여기가 쇼핑의 천국인가 싶었다. 많이 사진 않고 아이쇼핑하면서 실컷 구경했다.",
            "바토무슈 유람선을 타고 센 강을 따라 파리 구경",
            "에펠탑 야경을 보며 마시는 맥주. 아 너무 좋다.",
            "몽파르나스 타워 전망대에서 내려다본 파리",
            "몽쥬약국이 뭐하는 곳인가 했더니 파리에 오면 꼭 와봐야 할 쇼핑장소란다. 주변에서 사가지고 와달라는 화장품이 있어서 들렀다.",
            "안녕 파리! 다음 행선지는 스위스 인터라켄. 가서 신나게 놀아야지!"
        ]
        
        let transactionCategoryIndices: [Int] = [3, 4, 0, 2, 0, 1, 2, 0, 2, 1, 3]
        let transactionTimeIntervals: [TimeInterval] = [1503948060, 1503953340, 1504002960, 1504008600, 1504027140, 1504032960, 1504037100, 1504043180, 1504089000, 1504095060, 1504102980]
        let transactionPlaceName: [String] = ["파리 북역", "Generator Hostels", "Season", "루브르 박물관", "Café de la Paix", "샹젤리제 거리", "Bateaux-Mouches", "에펠탑", "몽파르나스타워", "몽쥬약국", "파리 리옹역"]
        let transactionCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 48.8809481, longitude: 2.3553137),
            CLLocationCoordinate2D(latitude: 48.8782378, longitude: 2.36995771),
            CLLocationCoordinate2D(latitude: 48.8651393, longitude: 2.3626373),
            CLLocationCoordinate2D(latitude: 48.8606111, longitude: 2.3376440),
            CLLocationCoordinate2D(latitude: 48.8709015, longitude: 2.3317596),
            CLLocationCoordinate2D(latitude: 48.8716884, longitude: 2.3016578),
            CLLocationCoordinate2D(latitude: 48.8640106, longitude: 2.3059374),
            CLLocationCoordinate2D(latitude: 48.8583701, longitude: 2.2944813),
            CLLocationCoordinate2D(latitude: 48.8421379, longitude: 2.3219514),
            CLLocationCoordinate2D(latitude: 48.8425708, longitude: 2.3519151),
            CLLocationCoordinate2D(latitude: 48.8443038, longitude: 2.3743773)
        ]
        
        for (index, categoryIndex) in transactionCategoryIndices.enumerated() {
            let transaction = Transaction()
            transaction.name = transactionNames[index]
            transaction.amount = transactionAmounts[index]
            transaction.currency = travel.currencies[1]
            transaction.isCash = transactionIsCashes[index]
            transaction.content = transactionContents[index]
            transaction.category = categories[categoryIndex]
            
            let dateInRegion = DateInRegion()
            dateInRegion.date = Date(timeIntervalSince1970: transactionTimeIntervals[index])
            dateInRegion.timeZone = TimeZone(identifier: "Europe/Paris")!
            transaction.dateInRegion = dateInRegion
            
            transaction.placeName = transactionPlaceName[index]
            transaction.coordinate = transactionCoordinates[index]
            
            travel.transactions.append(transaction)
        }
        
        try? realm.write {
            realm.add(travel)
        }
        
    }
}
