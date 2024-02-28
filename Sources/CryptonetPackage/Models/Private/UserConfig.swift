import Foundation

struct UserConfig: Codable {
    let imageFormat: String?
    let mfToken: String?
    let skipAntispoof: Bool?
    let documentScanBarcodeOnly: Bool?
    
    init(imageFormat: String? = nil, 
         mfToken: String? = nil,
         skipAntispoof: Bool? = nil,
         documentScanBarcodeOnly: Bool? = nil) {
        self.imageFormat = imageFormat
        self.mfToken = mfToken
        self.skipAntispoof = skipAntispoof
        self.documentScanBarcodeOnly = documentScanBarcodeOnly
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
        case mfToken = "mf_token"
        case documentScanBarcodeOnly = "document_scan_barcode_only"
    }
}
