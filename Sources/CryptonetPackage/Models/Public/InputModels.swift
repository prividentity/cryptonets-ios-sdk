import UIKit

public struct ValidConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
    }
}

public struct EstimageAgeConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
    }
}

public struct PredictConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
    }
}

public struct EnrollConfig: Codable {
    public let imageFormat: String
    public let mfToken: String?
    public let skipAntispoof: Bool
    
    public init(imageFormat: String = "rgba",
         mfToken: String? = nil,
         skipAntispoof: Bool = true) {
        self.imageFormat = imageFormat
        self.mfToken = mfToken
        self.skipAntispoof = skipAntispoof
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
        case mfToken = "mf_token"
    }
}

public struct DocumentFrontScanConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    public let confidenceScore: Double
    public let thresholdDocX: Double
    public let thresholdDocY: Double
    public let documentAutoRotation: Bool
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true,
         confidenceScore: Double = 0.3,
         thresholdDocX: Double = 0.02,
         thresholdDocY: Double = 0.02,
         documentAutoRotation: Bool = true) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
        self.confidenceScore = confidenceScore
        self.thresholdDocX = thresholdDocX
        self.thresholdDocY = thresholdDocY
        self.documentAutoRotation = documentAutoRotation
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
        case confidenceScore = "conf_score_thr_doc"
        case thresholdDocX = "threshold_doc_x"
        case thresholdDocY = "threshold_doc_y"
        case documentAutoRotation = "document_auto_rotation"
    }
}

public struct DocumentBackScanConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    public let documentScanBarcodeOnly: Bool
    public let thresholdDocX: Double
    public let thresholdDocY: Double
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true,
         documentScanBarcodeOnly: Bool = true,
         thresholdDocX: Double = 0.02,
         thresholdDocY: Double = 0.02) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
        self.documentScanBarcodeOnly = documentScanBarcodeOnly
        self.thresholdDocX = thresholdDocX
        self.thresholdDocY = thresholdDocY
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
        case documentScanBarcodeOnly = "document_scan_barcode_only"
        case thresholdDocX = "threshold_doc_x"
        case thresholdDocY = "threshold_doc_y"
    }
}

public struct DocumentAndFaceConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
    }
}

public struct CompareFacesConfig: Codable {
    public let imageFormat: String
    public let skipAntispoof: Bool
    public let faceMatchingThreshold: Double
    
    public init(imageFormat: String = "rgba",
         skipAntispoof: Bool = true,
                faceMatchingThreshold: Double = 1.24) {
        self.imageFormat = imageFormat
        self.skipAntispoof = skipAntispoof
        self.faceMatchingThreshold = faceMatchingThreshold
    }
    
    enum CodingKeys: String, CodingKey {
        case imageFormat = "input_image_format"
        case skipAntispoof = "skip_antispoof"
        case faceMatchingThreshold = "face_thresholds_med"
    }
}
