import Foundation

public extension Decodable {
    init(data: Data, using decoder: JSONDecoder = .init()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
    
    init(json: String, using decoder: JSONDecoder = .init()) throws {
        try self.init(data: Data(json.utf8), using: decoder)
    }
}
