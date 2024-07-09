import UIKit
import privid_fhe

enum CryptonetError: Error {
    case noJSON
    case failed
}

public class CryptonetPackage {
    
    public init() {}

    private var sessionPointer: UnsafeMutableRawPointer?
    
    public var version: String {
        let version = String(cString: privid_get_version(), encoding: .utf8)
        return version ?? ""
    }
    
    public func initializeSession(settings: NSString) -> Bool {
        let settingsPointer = UnsafeMutablePointer<CChar>(mutating: settings.utf8String)
        let sessionPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

        let isDone = privid_initialize_session(settingsPointer,
                                               UInt32(settings.length),
                                               sessionPointer)

        self.sessionPointer = sessionPointer.pointee
        return isDone
    }
    
    public func deinitializeSession() -> Result<Bool, Error> {
        guard let sessionPointer = self.sessionPointer else {
            return .failure(CryptonetError.failed)
        }
        
        privid_deinitialize_session(sessionPointer)
        return .success(true)
    }
    
    public func validate(image: UIImage, config: ValidConfig) -> Result<String, Error> {
        guard   let sessionPointer = self.sessionPointer,
                let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
                let cgImage = resized.cgImage else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let _ = privid_validate(sessionPointer,
                                    byteImageArray,
                                    imageWidth,
                                    imageHeight,
                                    userConfigPointer,
                                    Int32(userConfig.length),
                                    bufferOut,
                                    lengthOut)
            
            let outputString = convertToNSString(pointer: bufferOut)
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(outputString)
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func estimateAge(image: UIImage, config: EstimageAgeConfig) -> Result<String, Error> {
        guard   let sessionPointer = self.sessionPointer,
                let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
                let cgImage = resized.cgImage
        else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let _ =  privid_estimate_age(sessionPointer,
                                         byteImageArray,
                                         imageWidth,
                                         imageHeight,
                                         userConfigPointer,
                                         Int32(userConfig.length),
                                         bufferOut,
                                         lengthOut)
            
            let outputString = convertToNSString(pointer: bufferOut)
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(outputString)
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func enroll(image: UIImage, config: EnrollConfig) -> Result<String, Error> {
        guard let sessionPointer = self.sessionPointer,
              let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let cgImage = resized.cgImage,
              let imageData = resized.pngData() else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            let imageCount: Int32 = 1
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            let imageSize = Int32(imageData.count)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bestInputOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
            let bestInputLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let _ = privid_enroll_onefa(sessionPointer,
                                        userConfigPointer,
                                        Int32(userConfig.length),
                                        byteImageArray,
                                        imageCount,
                                        imageSize,
                                        imageWidth,
                                        imageHeight,
                                        bestInputOut,
                                        bestInputLengthOut,
                                        bufferOut,
                                        lengthOut)
            
            let outputString = convertToNSString(pointer: bufferOut)
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bestInputOut.deallocate()
            bestInputLengthOut.deallocate()
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(outputString)
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func predict(image: UIImage, config: PredictConfig) -> Result<String, Error> {
        guard let sessionPointer = self.sessionPointer,
              let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let cgImage = resized.cgImage,
              let imageData = resized.pngData() else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            let imageCount: Int32 = 1
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            let imageSize = Int32(imageData.count)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let _ = privid_face_predict_onefa(sessionPointer,
                                              userConfigPointer,
                                              Int32(userConfig.length),
                                              byteImageArray,
                                              imageCount,
                                              imageSize,
                                              imageWidth,
                                              imageHeight,
                                              bufferOut,
                                              lengthOut)
            
            let outputString = convertToNSString(pointer: bufferOut)
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(outputString)
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func userDelete(puid: NSString) -> String? {
        let puidPointer = UnsafeMutablePointer<CChar>(mutating: puid.utf8String)
        
        let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
        let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        
        let userConfig = NSString(string: "{}")
        let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
        
        let _ = privid_user_delete(sessionPointer,
                                   userConfigPointer,
                                   Int32(userConfig.length),
                                   puidPointer,
                                   Int32(puid.length),
                                   bufferOut,
                                   lengthOut)
        
        let outputString = convertToNSString(pointer: bufferOut)
        
        privid_free_char_buffer(bufferOut.pointee)
        
        bufferOut.deallocate()
        lengthOut.deallocate()
        
        return outputString
    }
    
    public func frontDocumentScan(image: UIImage, config: DocumentFrontScanConfig) -> Result<ScanModel, Error> {
        guard let sessionPointer = self.sessionPointer,
              let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let cgImage = resized.cgImage else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let croppedDocOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
            let croppedDocLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let croppedFaceOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
            let croppedFaceLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            
            let _ = privid_doc_scan_face(sessionPointer,
                                         userConfigPointer,
                                         Int32(userConfig.length),
                                         byteImageArray,
                                         imageWidth,
                                         imageHeight,
                                         croppedDocOut,
                                         croppedDocLengthOut,
                                         croppedFaceOut,
                                         croppedFaceLengthOut,
                                         bufferOut,
                                         lengthOut)
            
            let outputString = convertToNSString(pointer: bufferOut)
            var documentImage: UIImage? = nil
            var faceImage: UIImage? = nil
            
            if let outputString = outputString {
                let jsonData = Data(outputString.utf8)
                do {
                    let model = try JSONDecoder().decode(ScanDocumentFaceModel.self, from: jsonData)
                    documentImage = createImageFromRawData(rawData: croppedDocOut.pointee,
                                                           width: model.docFace?.documentData?.croppedDocumentImage?.info?.width,
                                                           height: model.docFace?.documentData?.croppedDocumentImage?.info?.height)
                    faceImage = createImageFromRawData(rawData: croppedFaceOut.pointee,
                                                       width: model.docFace?.croppedFaceImage?.info?.width,
                                                       height: model.docFace?.croppedFaceImage?.info?.height)
                    return .success(ScanModel(json: outputString, documentImage: documentImage, mugshotImage: faceImage))
                } catch {
                    return .success(ScanModel(json: outputString, documentImage: nil, mugshotImage: nil))
                }
            }
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            croppedDocOut.deallocate()
            croppedDocLengthOut.deallocate()
            
            croppedFaceOut.deallocate()
            croppedFaceLengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(ScanModel(json: outputString, documentImage: documentImage, mugshotImage: faceImage))
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func backDocumentScan(image: UIImage, config: DocumentBackScanConfig) -> Result<ScanModel, Error> {
        guard let sessionPointer = self.sessionPointer,
              let resized = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let cgImage = resized.cgImage else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            
            let byteImageArray = convertImageToRgbaRawBitmap(image: cgImage)
            
            let imageWidth = Int32(resized.size.width)
            let imageHeight = Int32(resized.size.height)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let croppedDocOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
            let croppedDocLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let croppedBarcodeOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
            let croppedBarcodeLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            
            let _ = privid_doc_scan_barcode(sessionPointer,
                                            userConfigPointer,
                                            Int32(userConfig.length),
                                            byteImageArray,
                                            imageWidth,
                                            imageHeight,
                                            croppedDocOut,
                                            croppedDocLengthOut,
                                            croppedBarcodeOut,
                                            croppedBarcodeLengthOut,
                                            bufferOut,
                                            lengthOut)
            
            let outputString = convertToNSStringForBarcode(pointer: bufferOut)
            
            var documentImage: UIImage? = nil
            var barcodeImage: UIImage? = nil
            
            if let outputString = outputString {
                let jsonData = Data(outputString.utf8)
                
                do {
                    let model = try JSONDecoder().decode(BarcodeDocumentModel.self, from: jsonData)
                    
                    documentImage = createImageFromRawData(rawData: croppedDocOut.pointee,
                                                           width: model.barcode?.documentData?.croppedDocumentImage?.info?.width ?? 0,
                                                           height: model.barcode?.documentData?.croppedDocumentImage?.info?.height ?? 0)
                    barcodeImage = createImageFromRawData(rawData: croppedBarcodeOut.pointee,
                                                          width: model.barcode?.documentBarcodeData?.croppedBarcodeImage?.info?.width ?? 0,
                                                          height: model.barcode?.documentBarcodeData?.croppedBarcodeImage?.info?.height)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            privid_free_char_buffer(bufferOut.pointee)
            
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            croppedDocOut.deallocate()
            croppedDocLengthOut.deallocate()
            
            croppedBarcodeOut.deallocate()
            croppedBarcodeLengthOut.deallocate()
            
            guard let outputString = outputString else { return .failure(CryptonetError.noJSON) }
            return .success(ScanModel(json: outputString, documentImage: documentImage, mugshotImage: barcodeImage))
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func compareDocumentAndFace(documentImage: UIImage, selfieImage: UIImage, config: DocumentAndFaceConfig) -> Result<String, Error> {
            guard let sessionPointer = self.sessionPointer else {
                return .failure(CryptonetError.failed)
            }
            
            guard let resizedDocumentImage = documentImage.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
                  let resizedSelfieImage = selfieImage.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
                  let cgDocumentImage = resizedDocumentImage.cgImage,
                  let cgSelfieImage = resizedSelfieImage.cgImage
            else {
                return .failure(CryptonetError.failed)
            }
            
            do {
                let configData = try JSONEncoder().encode(config)
                let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
                
                let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
                
                let byteDocumentImageArray = convertImageToRgbaRawBitmap(image: cgDocumentImage)
                
                let documentImageWidth = Int32(resizedDocumentImage.size.width)
                let documentImageHeight = Int32(resizedDocumentImage.size.height)
                
                let byteSelfieImageArray = convertImageToRgbaRawBitmap(image: cgSelfieImage)
                
                let selfieImageWidth = Int32(resizedSelfieImage.size.width)
                let selfieImageHeight = Int32(resizedSelfieImage.size.height)
                
                let croppedDocumentOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
                let croppedDocumentLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
                
                let croppedFaceOut = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 1)
                let croppedFaceLengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
                
                let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
                let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
                
                let _ = privid_compare_mugshot_and_face(sessionPointer,
                                                        userConfigPointer,
                                                        Int32(userConfig.length),
                                                        byteDocumentImageArray,
                                                        documentImageWidth,
                                                        documentImageHeight,
                                                        byteSelfieImageArray,
                                                        selfieImageWidth,
                                                        selfieImageHeight,
                                                        croppedDocumentOut,
                                                        croppedDocumentLengthOut,
                                                        croppedFaceOut,
                                                        croppedFaceLengthOut,
                                                        bufferOut,
                                                        lengthOut)
                
                guard let outputString = convertToNSString(pointer: bufferOut) else {
                    privid_free_char_buffer(bufferOut.pointee)
                    croppedDocumentOut.deallocate()
                    croppedDocumentLengthOut.deallocate()
                    croppedFaceOut.deallocate()
                    croppedFaceLengthOut.deallocate()
                    bufferOut.deallocate()
                    lengthOut.deallocate()
                    return .failure(CryptonetError.failed)
                }
                
                privid_free_char_buffer(bufferOut.pointee)
                croppedDocumentOut.deallocate()
                croppedDocumentLengthOut.deallocate()
                croppedFaceOut.deallocate()
                croppedFaceLengthOut.deallocate()
                bufferOut.deallocate()
                lengthOut.deallocate()
                
                return .success(String(outputString))
            } catch {
                return .failure(CryptonetError.failed)
            }
        }
    
    public func compareFaces(faceOne: UIImage, faceTwo: UIImage, config: CompareFacesConfig) -> Result<String, Error> {
        guard let sessionPointer = self.sessionPointer else {
            return .failure(CryptonetError.failed)
        }
        
        guard let resizedMugshotImage = faceOne.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let resizedSelfieImage = faceTwo.resizeImage(targetSize: CGSize(width: 1000, height: 1000)),
              let cgMugshotImage = resizedMugshotImage.cgImage,
              let cgSelfieImage = resizedSelfieImage.cgImage
        else {
            return .failure(CryptonetError.failed)
        }
        
        do {
            let configData = try JSONEncoder().encode(config)
            let userConfig = NSString(string: String(data: configData, encoding: .utf8)!)
            
            let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
            
            let byteMugshotImageArray = convertImageToRgbaRawBitmap(image: cgMugshotImage)
            
            let mugshotImageWidth = Int32(resizedMugshotImage.size.width)
            let mugshotImageHeight = Int32(resizedMugshotImage.size.height)
            
            let byteSelfieImageArray = convertImageToRgbaRawBitmap(image: cgSelfieImage)
            
            let selfieImageWidth = Int32(resizedSelfieImage.size.width)
            let selfieImageHeight = Int32(resizedSelfieImage.size.height)
            
            let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
            let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            
            let _ = privid_face_compare_files(sessionPointer,
                                              0.0,
                                              userConfigPointer,
                                              Int32(userConfig.length),
                                              byteMugshotImageArray,
                                              Int32(byteMugshotImageArray.count),
                                              mugshotImageWidth,
                                              mugshotImageHeight,
                                              byteSelfieImageArray,
                                              Int32(byteSelfieImageArray.count),
                                              selfieImageWidth,
                                              selfieImageHeight,
                                              bufferOut,
                                              lengthOut)
            
            guard let outputString = convertToNSString(pointer: bufferOut) else {
                privid_free_char_buffer(bufferOut.pointee)
                bufferOut.deallocate()
                lengthOut.deallocate()
                return .failure(CryptonetError.failed)
            }
            
            privid_free_char_buffer(bufferOut.pointee)
            bufferOut.deallocate()
            lengthOut.deallocate()
            
            return .success(String(outputString))
        } catch {
            return .failure(CryptonetError.failed)
        }
    }
    
    public func decryptEmbeddings(embeddings: NSString) -> Result<[CChar], Error> {
        guard let sessionPointer = self.sessionPointer else {
            return .failure(CryptonetError.failed)
        }

        let userConfig = NSString(string: "{}")
        let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
        
        let embeddingsPointer = UnsafeMutablePointer<CChar>(mutating: embeddings.utf8String)

        let bufferOut = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: 1)
        let lengthOut = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        
        let _ = privid_get_embeddings(sessionPointer,
                                userConfigPointer,
                                Int32(userConfig.length),
                                embeddingsPointer,
                                Int32(embeddings.length),
                                bufferOut,
                                lengthOut)
        
        
        let outArray = Array(UnsafeBufferPointer(start: bufferOut.pointee, count: Int(lengthOut.pointee)))
    
        privid_free_char_buffer(bufferOut.pointee)
        bufferOut.deallocate()
        lengthOut.deallocate()
        
        return .success(outArray)
    }
    
    public func compareEmbeddings(embeddingsOne: [CChar], embeddingsTwo: [CChar]) -> Result<Float, Error> {
        guard let sessionPointer = self.sessionPointer else {
            return .failure(CryptonetError.failed)
        }

        let userConfig = NSString(string: "{}")
        let userConfigPointer = UnsafeMutablePointer<CChar>(mutating: userConfig.utf8String)
        
        let bufferOne = UnsafeMutablePointer<CChar>.allocate(capacity: embeddingsOne.count)
        bufferOne.initialize(from: embeddingsOne, count: embeddingsOne.count)
        
        let bufferTwo = UnsafeMutablePointer<CChar>.allocate(capacity: embeddingsTwo.count)
        bufferTwo.initialize(from: embeddingsTwo, count: embeddingsTwo.count)

        let result = privid_compare_embeddings(sessionPointer,
                                userConfigPointer,
                                Int32(userConfig.length),
                                bufferOne,
                                Int32(embeddingsOne.count),
                                bufferTwo,
                                Int32(embeddingsTwo.count))

        return .success(result)
    }
}

private extension CryptonetPackage {
    func convertImageToRgbaRawBitmap(image: CGImage) -> [UInt8] {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        
        var rawData = [UInt8](repeating: 0, count: image.width * image.height * bytesPerPixel)
        
        let context = CGContext(
            data: &rawData, width: image.width, height: image.height,
            bitsPerComponent: bitsPerComponent, bytesPerRow: image.width * bytesPerPixel,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        return rawData
    }
    
    func createImageFromRawData(rawData: UnsafeMutableRawPointer?, width: Double?, height: Double?) -> UIImage? {
        let bitsPerComponent = 8
        _ = 32
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let width = Int(width ?? 0)
        let height = Int(height ?? 0)
        
        guard let context = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: width * 4,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    func convertToNSString(pointer: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>) -> String? {
        guard let cStringPointer = pointer.pointee else { return nil }
        return String(NSString(utf8String: cStringPointer) ?? "")
    }
    
    func convertToNSStringForBarcode(pointer: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>) -> String? {  // TEMP SOLUTION
        guard let cStringPointer = pointer.pointee else { return nil }
        var string = String(NSString(utf8String: cStringPointer) ?? "")
        if let dotRange = string.range(of: "),") {
            string.removeSubrange(dotRange.lowerBound..<string.endIndex)
        }
        
        return string
    }
}
