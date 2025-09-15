//
//  AddressService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import Foundation

protocol AddressServiceProtocol {
    func fetchAddressList() async throws -> [AddressModel]
    func addAddress(name: String, typeName: String, phone: String, address: String, city: String, state: String, postalCode: String) async throws
    func updateAddress(addressId: Int, name: String, typeName: String, phone: String, address: String, city: String, state: String, postalCode: String) async throws 
    func removeAddress(addressId: Int) async throws 
}

final class AddressService: AddressServiceProtocol {
    
    func fetchAddressList() async throws -> [AddressModel] {
        try await ServiceCall.post(
            path: Globs.SV_ADDRESS_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: [AddressModel].self
        )
    }
    
    func addAddress(
        name: String,
        typeName: String,
        phone: String,
        address: String,
        city: String,
        state: String,
        postalCode: String
    ) async throws {
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_ADD_ADDRESS,
            parameters: [
                "name": name,
                "type_name": typeName,
                "phone": phone,
                "address": address,
                "city": city,
                "state": state,
                "postal_code": postalCode
            ],
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }
    
    func updateAddress(
        addressId: Int,
        name: String,
        typeName: String,
        phone: String,
        address: String,
        city: String,
        state: String,
        postalCode: String
    ) async throws {
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_UPDATE_ADDRESS,
            parameters: [
                "address_id": addressId,
                "name": name,
                "type_name": typeName,
                "phone": phone,
                "address": address,
                "city": city,
                "state": state,
                "postal_code": postalCode
            ],
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }
    
    func removeAddress(addressId: Int) async throws {
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_REMOVE_ADDRESS,
            parameters: [
                "address_id": addressId
            ],
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }

}
