//
//  FetchMoviesService.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//


//import Foundation
//
//class FetchMoviesService: BaseService<BaseModel(), BaseError()> {
//    
//    override func startBusinessLogic(params: VFVoid, completion: @escaping (VFResult<VFChatConfigArrResponseModel, DXLAppError>) -> Void) {
//        let selectedService = VFLoggedUserSitesDetailsModel.shared.currentService?.id ?? ""
//        let request = VFBaseDxlRequest<VFChatConfigArrResponseModel, VFDxlError>(path: .chatConfiguration(selectedService: selectedService), httpMethod: .get) { (result) in
//            let serviceResult: VFResult<VFChatConfigArrResponseModel, DXLAppError>
//            switch result{
//            case .success(let model):
//                serviceResult = .success(model)
//            case .failure(let err):
//                serviceResult = .failure(err.appErr)
//            }
//            completion(serviceResult)
//        }
//        startRequest(request)
//    }
//    
//}

