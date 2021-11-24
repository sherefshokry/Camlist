//
//  VenueViewControllerTests.swift
//  CamlistTests
//
//  Created by SherifShokry on 23/11/2021.
//
import XCTest
@testable import Camlist
import CoreLocation

class VenueViewControllerTests: XCTestCase {

   
    func test_loadVenueCompletion_rendersSuccessfullyLoadedVenues(){
        let venue0 = Venue(id: "1", name: "venue1", location: VenueLocation(address: "address1"))
        let venue1 = Venue(id: "2", name: "venue2", location: VenueLocation(address: "address2"))
        let venue2 = Venue(id: "3", name: "venue3", location: VenueLocation(address: "address3"))
        let venue3 = Venue(id: "4", name: "venue4", location: VenueLocation(address: nil))
        let (sut,useCase) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        useCase.completeVenueLoading(with: [venue0,venue1], at: 0)
        assertThat(sut, isRendering: [venue0,venue1])

        
        sut.simulateReloadingVenueAfter500Meter()

        useCase.completeVenueLoading(with: [venue0,venue1,venue2,venue3], at: 1)
        assertThat(sut, isRendering: [venue0,venue1,venue2,venue3])
        
    }
    
    //MARK: - Helpers

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (VenueViewController,FetchVenueUseCaseSpy){
        let fetchVenueUseCase = FetchVenueUseCaseSpy()
        let fetchVenueImageUseCase = fetchVenueImageUseCaseSpy()
        let locationManagerService = LocationManagerServiceMock()
        let sut = VenueUIComposer.venueComposedWith(fetchVenueUseCase: fetchVenueUseCase, fetchVenueImageUseCase: fetchVenueImageUseCase,locationManager: locationManagerService)
        trackForMemoryLeaks(sut, file, line)
       // trackForMemoryLeaks(fetchVenueUseCase, file, line)
        return (sut,fetchVenueUseCase)
    }
    
    
    private func assertThat(_ sut: VenueViewController,isRendering venue: [Venue],file: StaticString = #file, line: UInt = #line){
    
//        guard sut.numberOfRenderedVenueViews() == venue.count else{
//            return XCTFail("Expected \(venue.count) Venues, got \(sut.numberOfRenderedVenueViews()) instead.",file: file,line: line)
//        }
        
        venue.enumerated().forEach { index,venue in
            assertThat(sut, hasViewConfiguredFor: venue, at: index,file: file,line: line)
        }
        
    }
        
    private func assertThat(_ sut: VenueViewController,hasViewConfiguredFor item: Venue,at index: Int,file: StaticString = #file, line: UInt = #line){
        let view = sut.venueView(at: index) as? VenueCell
        
        XCTAssertNotNil(view,file: file,line: line)
        XCTAssertEqual(view?.titleText, item.name,file: file,line: line)
        XCTAssertEqual(view?.addressText , item.location.address,file: file,line: line)
    }
    
    class LocationManagerServiceMock: LocationManagerService{
        func getLocation(completionHandler: @escaping LocationClosure) {
            completionHandler(CLLocation(latitude: 55.213448, longitude: 20.608194),nil)
        }
    }
    
    class FetchVenueUseCaseSpy: FetchVenueUseCase{
      
        private var venueRequests = [(completion: Result<[Venue], Error>) -> ()]()
       
        var loadVenueCallCount: Int {
            return venueRequests.count
        }
        
        
        func execute(completion: @escaping (Result<[Venue], Error>) -> Void) {
            venueRequests.append(completion)
        }
        
        func completeVenueLoading(with venueItem: [Venue] = [],at index: Int) {
            venueRequests[index](.success(venueItem))
        }
        
        func completeVenueLoadingWithError(at index: Int) {
            let error = NSError(domain: "an Error", code: 0)
            venueRequests[index](.failure(error))
        }
        
    }
    
    
  class fetchVenueImageUseCaseSpy: FetchVenueImageUseCase{
        //MARK: - Image Data Loader
        
        func execute(cached: @escaping (VenueImage) -> Void, completion: @escaping (Result<VenueImage, Error>) -> Void) {
            
        }
    }

    
    
}

private extension VenueViewController {
   
    func venueView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: venueImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func numberOfRenderedVenueViews() -> Int {
        
        return tableView.numberOfRows(inSection: venueImagesSection)
    }
    
    var venueImagesSection : Int {
        return 0
    }
    
    
    func simulateReloadingVenueAfter500Meter(){
        venueUpdateController?.loadVenueData()
    }
    
}


private extension VenueCell{
    
    var titleText: String? {
        return titleLabel.text
    }

    var addressText: String?{
        return addressLabel.text
    }
    
}
