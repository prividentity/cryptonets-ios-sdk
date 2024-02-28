import UIKit

 struct ScanDocumentFaceModel: Codable {
    let error: Int?
    let payloadType: String?
    let imageWidth, imageHeight, docCenterX, docCenterY: Double?
    let docX1, docY1, docX2, docY2: Double?
    let docX3, docY3, docX4, docY4: Double?
    let confLevel: Double?
    let croppedDocWidth, croppedDocHeight, croppedDocChannels, docValidationStatus: Double?
    let puid, guid, predictMessage, faceValidityMessage: String?
    let opMessage: String?
    let predictStatus, enrollLevel, faceValid, opStatus: Int?
    let croppedFaceWidth, croppedFaceHeight, croppedFaceSize, croppedFaceChannels: Double?
    var transactionId: Int?
    var json: String?
    var xas: Data?
    var faceImage: UIImage?
    var documentImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case error
        case payloadType = "payload_type"
        case imageWidth = "image_width"
        case imageHeight = "image_height"
        case docCenterX = "doc_center_x"
        case docCenterY = "doc_center_y"
        case docX1 = "doc_x1"
        case docY1 = "doc_y1"
        case docX2 = "doc_x2"
        case docY2 = "doc_y2"
        case docX3 = "doc_x3"
        case docY3 = "doc_y3"
        case docX4 = "doc_x4"
        case docY4 = "doc_y4"
        case confLevel = "conf_level"
        case croppedDocWidth = "cropped_doc_width"
        case croppedDocHeight = "cropped_doc_height"
        case croppedDocChannels = "cropped_doc_channels"
        case docValidationStatus = "doc_validation_status"
        case puid, guid
        case predictMessage = "predict_message"
        case faceValidityMessage = "face_validity_message"
        case opMessage = "op_message"
        case predictStatus = "predict_status"
        case enrollLevel = "enroll_level"
        case faceValid = "face_valid"
        case opStatus = "op_status"
        case croppedFaceWidth = "cropped_face_width"
        case croppedFaceHeight = "cropped_face_height"
        case croppedFaceSize = "cropped_face_size"
        case croppedFaceChannels = "cropped_face_channels"
    }
}

public struct BarcodeDocumentModel: Codable {
    let opStatus, readBarcodeResult: Int?
    let opMessage, payloadType: String?
    let imageWidth, imageHeight, barcodeConfScore, barcodeCX0: Double?
    let barcodeCY0, barcodeX1, barcodeY1, barcodeX2: Double?
    let barcodeY2, barcodeX3, barcodeY3, barcodeX4: Double?
    let barcodeY4, cropImgTopleftX, cropImgTopleftY, cropImgBotrightX: Double?
    let cropImgBotrightY, cropDocWidth, cropDocHeight, cropDocBytes: Double?
    let cropDocChannels, cropBarcodeWidth, cropBarcodeHeight, cropBarcodeBytes: Double?
    let cropBarcodeChannels: Double?
    let type, format, documentID, customerID: String?
    let firstName, lastName, middleName, expirationDate: String?
    let issueDate, dateOfBirth, gender, eyeColor: String?
    let hairColor, height, streetAddress1, streetAddress2: String?
    let restStreetAddress1, restStreetAddress2, city, state: String?
    let postCode, issuingCountry, firstNameTruncation, placeOfBirth: String?
    let auditInformation, inventoryControlNumber, lastNameAlias, firstNameAlias: String?
    let suffixAlias, nameSuffix, namePrefix, barcodeKeyString: String?
    let barcodeKeyStringEncoding, barcodeHash64String, barcodeHash128String: String?
    var transactionId: Int?
    var json: String?
    var barcodeImage: UIImage?
    var documentImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case opStatus = "op_status"
        case readBarcodeResult = "read_barcode_result"
        case opMessage = "op_message"
        case payloadType = "payload_type"
        case imageWidth = "image_width"
        case imageHeight = "image_height"
        case barcodeConfScore = "barcode_conf_score"
        case barcodeCX0 = "barcode_c_x0"
        case barcodeCY0 = "barcode_c_y0"
        case barcodeX1 = "barcode_x1"
        case barcodeY1 = "barcode_y1"
        case barcodeX2 = "barcode_x2"
        case barcodeY2 = "barcode_y2"
        case barcodeX3 = "barcode_x3"
        case barcodeY3 = "barcode_y3"
        case barcodeX4 = "barcode_x4"
        case barcodeY4 = "barcode_y4"
        case cropImgTopleftX = "crop_img_topleft_x"
        case cropImgTopleftY = "crop_img_topleft_y"
        case cropImgBotrightX = "crop_img_botright_x"
        case cropImgBotrightY = "crop_img_botright_y"
        case cropDocWidth = "crop_doc_width"
        case cropDocHeight = "crop_doc_height"
        case cropDocBytes = "crop_doc_bytes"
        case cropDocChannels = "crop_doc_channels"
        case cropBarcodeWidth = "crop_barcode_width"
        case cropBarcodeHeight = "crop_barcode_height"
        case cropBarcodeBytes = "crop_barcode_bytes"
        case cropBarcodeChannels = "crop_barcode_channels"
        case type, format
        case documentID = "documentId"
        case customerID = "customerId"
        case firstName, lastName, middleName, expirationDate, issueDate, dateOfBirth, gender, eyeColor, hairColor, height, streetAddress1, streetAddress2
        case restStreetAddress1 = "RestStreetAddress1"
        case restStreetAddress2 = "RestStreetAddress2"
        case city, state, postCode, issuingCountry, firstNameTruncation, placeOfBirth, auditInformation, inventoryControlNumber, lastNameAlias, firstNameAlias, suffixAlias, nameSuffix, namePrefix
        case barcodeKeyString = "barcode_key_string"
        case barcodeKeyStringEncoding = "barcode_key_string_encoding"
        case barcodeHash64String = "barcodeHash64_string"
        case barcodeHash128String = "barcodeHash128_string"
    }
}
