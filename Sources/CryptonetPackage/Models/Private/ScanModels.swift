import UIKit

struct ScanDocumentFaceModel: Codable {
    let callStatus: DocumentCallStatus?
    let docFace: DocFace?

    enum CodingKeys: String, CodingKey {
        case callStatus = "call_status"
        case docFace = "doc_face"
    }
}

struct DocumentCallStatus: Codable {
    let returnStatus: Int?
    let operationTag, returnMessage, mfToken: String?
    let operationID, operationTypeID: Int?

    enum CodingKeys: String, CodingKey {
        case returnStatus = "return_status"
        case operationTag = "operation_tag"
        case returnMessage = "return_message"
        case mfToken = "mf_token"
        case operationID = "operation_id"
        case operationTypeID = "operation_type_id"
    }
}

struct DocFace: Codable {
    let documentData: DocumentData?
    let croppedFaceImage: CroppedImage?
    let faceValidityMessage, uuid, guid, predictMessage: String?
    let opMessage: String?
    let predictStatus, enrollLevel: Int?

    enum CodingKeys: String, CodingKey {
        case documentData = "document_data"
        case croppedFaceImage = "cropped_face_image"
        case faceValidityMessage = "face_validity_message"
        case uuid, guid
        case predictMessage = "predict_message"
        case opMessage = "op_message"
        case predictStatus = "predict_status"
        case enrollLevel = "enroll_level"
    }
}

struct CroppedImage: Codable {
    let info: Info?
    let data: String?
}

struct Info: Codable {
    let width, height: Double?
    let channels, depths, color: Int?
}

struct DocumentData: Codable {
    let documentConfLevel: Double?
    let documentBoxCenter: DocumentBoxCenter?
    let croppedDocumentBox: CroppedDocumentBox?
    let croppedDocumentImage: CroppedImage?
    let documentValidationStatus: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case documentConfLevel = "document_conf_level"
        case documentBoxCenter = "document_box_center"
        case croppedDocumentBox = "cropped_document_box"
        case croppedDocumentImage = "cropped_document_image"
        case documentValidationStatus = "document_validation_status"
        case statusMessage = "status_message"
    }
}

struct CroppedDocumentBox: Codable {
    let topLeft, topRight, bottomRight, bottomLeft: DocumentBoxCenter?

    enum CodingKeys: String, CodingKey {
        case topLeft = "top_left"
        case topRight = "top_right"
        case bottomRight = "bottom_right"
        case bottomLeft = "bottom_left"
    }
}

struct DocumentBoxCenter: Codable {
    let x, y: Int?
}

struct BarcodeDocumentModel: Codable {
    let callStatus: DocumentCallStatus?
    let barcode: Barcode?

    enum CodingKeys: String, CodingKey {
        case callStatus = "call_status"
        case barcode
    }
}

// MARK: - Barcode
struct Barcode: Codable {
    let documentData: DocumentData?
    let documentBarcodeData: DocumentBarcodeData?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case documentData = "document_data"
        case documentBarcodeData = "document_barcode_data"
        case message
    }
}

// MARK: - DocumentBarcodeData
struct DocumentBarcodeData: Codable {
    let barcodeConfScore: Double?
    let barcodeBoxCenter: BarcodeBoxCenter?
    let nonCroppedBarcodeBox, croppedBarcodeBox: Box?
    let croppedBarcodeImage: CroppedImage?
    let barCodeDetectionStatus: Int?
    let barcodeData: BarcodeData?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case barcodeConfScore = "barcode_conf_score"
        case barcodeBoxCenter = "barcode_box_center"
        case nonCroppedBarcodeBox = "non_cropped_barcode_box"
        case croppedBarcodeBox = "cropped_barcode_box"
        case croppedBarcodeImage = "cropped_barcode_image"
        case barCodeDetectionStatus = "bar_code_detection_status"
        case barcodeData = "barcode_data"
        case statusMessage = "status_message"
    }
}

// MARK: - BarcodeBoxCenter
struct BarcodeBoxCenter: Codable {
    let x, y: Double?
}

// MARK: - BarcodeData
struct BarcodeData: Codable {
    let type, format, text, firstName: String?
    let lastName, middleName, expirationDate, issueDate: String?
    let dateOfBirth, gender, eyeColor, hairColor: String?
    let height, streetAddress1, streetAddress2, resStreetAddress1: String?
    let resStreetAddress2, city, state, postalCode: String?
    let customerID, documentID, issuingCountry, middleNameTruncation: String?
    let firstNameTruncation, lastNameTruncation, placeOfBirth, auditInformation: String?
    let inventoryControlNumber, lastNameAlias, firstNameAlias, suffixAlias: String?
    let nameSuffix, namePrefix, barcodeKey, barcodeKeyEncoding: String?
    let barcodeHash64, barcodeHash128, documentType: String?

    enum CodingKeys: String, CodingKey {
        case type, format, text
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case expirationDate = "expiration_date"
        case issueDate = "issue_date"
        case dateOfBirth = "date_of_birth"
        case gender
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case height
        case streetAddress1 = "street_address1"
        case streetAddress2 = "street_address2"
        case resStreetAddress1 = "res_street_address1"
        case resStreetAddress2 = "res_street_address2"
        case city, state
        case postalCode = "postal_code"
        case customerID = "customer_id"
        case documentID = "document_id"
        case issuingCountry = "issuing_country"
        case middleNameTruncation = "middle_name_truncation"
        case firstNameTruncation = "first_name_truncation"
        case lastNameTruncation = "last_name_truncation"
        case placeOfBirth = "place_of_birth"
        case auditInformation = "audit_information"
        case inventoryControlNumber = "inventory_control_number"
        case lastNameAlias = "last_name_alias"
        case firstNameAlias = "first_name_alias"
        case suffixAlias = "suffix_alias"
        case nameSuffix = "name_suffix"
        case namePrefix = "name_prefix"
        case barcodeKey = "barcode_key"
        case barcodeKeyEncoding = "barcode_key_encoding"
        case barcodeHash64 = "barcode_hash64"
        case barcodeHash128 = "barcode_hash128"
        case documentType = "document_type"
    }
}


struct Box: Codable {
    let confScore: Double?
    let topLeft, bottomRight, eyeLeft, eyeRight: BarcodeBoxCenter?

    enum CodingKeys: String, CodingKey {
        case confScore = "conf_score"
        case topLeft = "top_left"
        case bottomRight = "bottom_right"
        case eyeLeft = "eye_left"
        case eyeRight = "eye_right"
    }
}

