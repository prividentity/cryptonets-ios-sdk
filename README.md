# Cryptonets iOS SDK

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [API Documentation](#api-documentation)
- [Example App](#example-app)

## Overview

Private ID iOS SDK supports user registration with identity proofing, and user face login with FIDO Passkey, using Cryptonets fully homomorphically encrypted (FHE) for privacy and security.

Features:
- Biometric face registration and authentication compliant with IEEE 2410-2021 Standard for Biometric Privacy, and exempt from GDPR, CCPA, BIPA, and HIPPA privacy law obligations.
- Face registration and 1:n face login in 200ms constant time
- Biometric age estimation with full privacy, on-device in 20ms
- Unlimited users (unlimited gallery size)
- Fair, accurate and unbiased
- Operates online or offline, using local cache for hyper-scalability

Builds
- Verified Identity
- Identity Assurance
- Authentication Assurance
- Federation Assurance
- Face Login
- Face Unlock
- Biometric Access Control
- Account Recovery
- Face CAPTCHA

## Installation

### Requirements
- Xcode 14.1 or later
- iOS 14.0 or later

### Steps:

1. In Xcode, with your app project open, navigate to File > Add Packages.
2. When prompted, add the `CryptonetPackage` SDK repository:

```swift
https://github.com/prividentity/cryptonets-ios-sdk
```
3. Link your Target to the SDK.

## API Documentation

### Version

A value that returns the current SDK version.

```swift
var version: String
```

**Returns:**

- `String`: value for the current version.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let version = cryptonet.version
```

### Initialize Session

A method that creates the session for SDK work. It saves the session pointer inside the SDK for future usage. Please use it before making any other calls.

```swift
func initializeSession(settings: NSString) -> Bool
```

**Parameters:**

- `settings: NSString`: session initialization settings.

**Returns:**

- `Bool`: if the session is created it returns 'true'. 

**Example:**

```swift
let settings = """
{
 "collections": {
    "default": {
        "named_urls": {
            "base_url": "<base_url>"
        }
    }
  },
  "session_token": "<session_token>",
  "debug_level": "<debug_level>"
}
"""
let cryptonet = CryptonetPackage()
let result = cryptonet.initializeSession(settings: settings)
```

### Deinitialize Session

A method that deinitializes the session created before. When you no longer need SDK in your work, you can call this function, which frees memory and closes the session.

```swift
func deinitializeSession() -> Result<Bool, Error>
```

**Returns:**

- `Result<Bool, Error>`: if the session is closed it returns 'true'. 

**Example:**

```swift
let cryptonet = CryptonetPackage()
let result = cryptonet.deinitializeSession()
```

### Validate Face

A function that detects if there is a valid face on the photo or video element.

```swift
func validate(image: UIImage, config: ValidConfig) -> Result<String, Error>
```

**Parameters:**

- `image: UIImage`: input image for validation.
- `config: ValidConfig`: user's config for changing settings. 

The `ValidConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.

**Returns:**

- `Result<String, Error>`: string is a `JSON` representing the face status.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = ValidConfig()
let result = cryptonet.validate(image: image, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(let error):
        // ...
}
```

### Estimate Age

Estimate the user's age based on the photo or video element.

```swift
func estimateAge(image: UIImage, config: EstimageAgeConfig) -> Result<String, Error>
```

**Parameters:**

- `image`: input image for estimation.
- `EstimageAgeConfig`: user's config for changing settings. 

The `EstimageAgeConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.

**Returns:**

- `Result<String, Error>`: string is a `JSON` result.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = EstimageAgeConfig()
let result = cryptonet.estimateAge(image: image, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(_):
        // ...
}
```

### Enroll Person

Perform a new enrollment (register a new user) using the enroll function. The function will collect 5 consecutive, valid faces to be able to enroll. Using configuration, we must pass the same `mfToken` (Multiframe token) on success. If the `mfToken` value changes, we will have an invalid enrollment image and start again from the beginning. **Note:** 5 consecutive faces are needed. When enrollment is successful after 5 consecutive valid faces, enroll returns the enrollment result.

```swift
func enroll(image: UIImage, config: EnrollConfig) -> Result<String, Error>
```

**Parameters:**

- `image: UIImage`: input image for enrolment.
- `config: EnrollConfig`: user's config for changing settings.
  
The `EnrollConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.

**Returns:**

- `Result<String, Error>`: string is a `JSON` result.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = EnrollConfig(mfToken: <mfToken: String>)
let result = cryptonet.enroll(image: image, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(_):
        // ...
}
```

### Predict Person

Perform predict (authenticate a user) after enrolling the user. This method returns a GUID/PUID if the prediction is successful; otherwise, face validation status and anti-spoof status code from the JSON response. You can get code descriptions at the end of the documentation. However, if the user is not enrolled in the system, this call will return a status of -1 and the message "User not enrolled."

```swift
func predict(image: UIImage, config: PredictConfig) -> Result<String, Error>
```

**Parameters:**

- `image: UIImage`: input image for prediction.
- `config: PredictConfig`:  user's config for changing settings.

The `PredictConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.

**Returns:**

- `Result<String, Error>`: string is a `JSON` result.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = PredictConfig()
let result = cryptonet.predict(image: image, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(_):
        // ...
}
```

### Delete User

Delete a user from the system.

```swift
func userDelete(puid: NSString) -> String?
```

**Parameters:**

- `puid: NSString`: user identifier.

**Returns:**

- `String?`: string is a `JSON` result.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let response = cryptonet.userDelete(puid: <puid: String>)
```

### Compare Document and Face

```swift
func compareDocumentAndFace(documentImage: UIImage, selfieImage: UIImage, config: DocumentAndFaceConfig) -> Result<String, Error>
```

**Parameters:**

- `documentImage: UIImage`: user's document image.
- `selfieImage: UIImage`: user's face image.
- `config: DocumentAndFaceConfig`: user's config for changing settings.
  
The `DocumentAndFaceConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.
3) `blurThreshold` - `15.0`: the threshold for marking input mugshot face as blurry. Smaller values are less restrictive, and `0.0` means no blurriness check.

**Returns:**

- `Result<String, Error>`: string is a `JSON` result.

**Example:**

```swift
let config = DocumentFrontScanAndSelfieConfig()
let cryptonet = CryptonetPackage()
let result = cryptonet.compareDocumentAndSelfieImages(documentImage: <image: UIImage>, selfieImage: <image: UIImage>, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(_):
        // ...
}
```

A sample JSON result:

```json
{
 "call_status": {
  "return_status": 0,
  "operation_tag": "compare_mugshot_and_face",
  "return_message": "",
  "mf_token": "",
  "operation_id": 17,
  "operation_type_id": 12
 },
 "face_compare": {
  "result": 0,
  "a_face_validation_status": 0,
  "b_face_validation_status": 0,
  "distance_min": 0.964277208,
  "distance_mean": 0.964277208,
  "distance_max": 0.964277208,
  "conf_score": 56.8121185,
  "face_thresholds": [],
  "document_data": {
   "document_conf_level": 0,
   "cropped_document_image": {
    "info": {
     "width": 112,
     "height": 112,
     "channels": 4,
     "depths": 0,
     "color": 4
    },
    "data": ""
   },
   "document_validation_status": 0,
   "status_message": "",
   "mrz_text": []
  },
  "cropped_face_image": {
   "info": {
    "width": 112,
    "height": 112,
    "channels": 4,
    "depths": 0,
    "color": 4
   },
   "data": ""
  }
 }
}
```

### Compare Faces

```swift
func compareFaces(faceOne: UIImage, faceTwo: UIImage, config: CompareFacesConfig) -> Result<String, Error>
```

**Parameters:**

- `faceOne: UIImage`: user's first image.
- `faceTwo: UIImage`: user's second image.
- `config: CompareFacesConfig`: user's config for changing settings.
  
The `CompareFacesConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.
3) `faceMatchingThreshold` - `1.24`: Threshold for matching faces.

**Returns:**

- `Result<String, Error>`: string is a `JSON` result.

**Example:**

```swift
let config = CompareFilesConfig()
let cryptonet = CryptonetPackage()
let result = cryptonet.compareFaces(selfieImage: <image: UIImage>, mugshotImage: <image: UIImage>, config: config)
switch result {
    case .success(let json):
        // ...
    case .failure(_):
        // ...
}
```

A sample JSON result:

```json
{
 "call_status": {
  "return_status": 0,
  "operation_tag": "compare_files",
  "return_message": "",
  "mf_token": "",
  "operation_id": 11,
  "operation_type_id": 6
 },
 "face_compare": {
  "result": 1,
  "a_face_validation_status": 0,
  "b_face_validation_status": 0,
  "distance_min": 0.881899476,
  "distance_mean": 0.881899476,
  "distance_max": 0.881899476,
  "conf_score": 0.711803317,
  "face_thresholds": [
   0.3,
   1.24,
   0.65
  ]
 }
}
```

### Front Document Scan

This function allows you to scan data from the front side of the document (government ID or driver's license).

```swift
func frontDocumentScan(image: UIImage, config: DocumentFrontScanConfig) -> Result<ScanModel, Error>
```

**Parameters:**

- `image: UIImage`: input image for scanning document.
- `config: DocumentFrontScanConfig`: user's config for changing settings.
  
The `DocumentFrontScanConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.
3) `thresholdDocX` - `0.2`: the minimal allowed distance (as the ratio of input image width) between the detected document edge and the left/right sides of the input image.
4) `thresholdDocY` - `0.2`: the minimal allowed distance (as the ratio of input image height) between the detected document edge and the top/bottom sides of the input image.
5) `documentAutoRotation` - `true`: If the value is 'true,' the function will rotate the input image several times for better detection results.
6) `blurThreshold` - `15.0`: the threshold for marking input mugshot face as blurry. Smaller values are less restrictive, and `0.0` means no blurriness check.

**Returns:**

- `Result<ScanModel, Error>`: the `ScanModel` is an object that contains JSON result, recognized document image, and mugshot image (face image of the front document).

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = DocumentFrontScanConfig()
let result = cryptonet.frontDocumentScan(image: image, config: config)
switch result {
    case .success(let response):
        // ...
    case .failure(_):
        // ...
}
```

### Back Document Scan

This function allows you to scan data from the back side of the document (government ID or driver's license). This method accepts a valid image of the back side of the ID document with a PTD417 barcode. It returns a cropped document and barcode images, as well as a resulting JSON document that contains barcode parsing results, if any. Note: high input image resolution is essential for better barcode parsing results.

```swift
func backDocumentScan(image: UIImage, config: DocumentBackScanConfig) -> Result<ScanModel, Error>
```

If you want to scan the barcode, use the `documentScanBarcodeOnly` parameter equal to `true` for faster processing.

**Parameters:**

- `image: UIImage`: input image for scanning document.
- `config: DocumentBackScanConfig`: user's config for changing settings.

The `DocumentBackScanConfig` has default values:

1) `imageFormat` - `"rgba"`: the SDK expects the RGBA image format.
2) `skipAntispoof` - `true`: anti-spoof is not enabled by default.
3) `documentScanBarcodeOnly` - `true`: if you need to scan the whole document, you should use the `false` value here.
4) `thresholdDocX` - `0.2`: the minimal allowed distance (as the ratio of input image width) between the detected document edge and the left/right sides of the input image.
5) `thresholdDocY` - `0.2`: the minimal allowed distance (as the ratio of input image height) between the detected document edge and top/bottom sides of the input image.

**Returns:**

- `Result<ScanModel, Error>`: the `ScanModel` is an object that contains a `JSON` result, recognized document image (if any), and barcode image.

**Example:**

```swift
let cryptonet = CryptonetPackage()
let config = DocumentBackScanConfig()
let result = cryptonet.backDocumentScan(image: image, config: config)
switch result {
    case .success(let response):
        // ...
    case .failure(_):
        // ...
}
```

## SDK Status Codes

### Face Validation Status

* -100 Internal Error
* -1 No Face Found
* 0 Valid Face
* 1 Image Spoof (Not Used)
* 2 Video Spoof (Not Used)
* 3 Too Close
* 4 Too Close
* 5 Too far to right (Close to right edge of image)
* 6 Too far to left (Close to left edge of image)
* 7 Too far up (Close to top edge of image)
* 8 Too far down (Close to bottom edge of image)
* 9 Too Blurry
* 10 Glasses Detected
* 11 Facemask Detected
* 12 Chin too far left
* 13 Chin too far right
* 14 Chin too far up
* 15 Chin too far down
* 16 Image too dim
* 17 Image too bright
* 18 Face low confidence value
* 19 Invalid face background (Not used)
* 20 Eyes blink
* 21 Mouth Open
* 22 Face tilted right
* 23 Face rotated left

### Anti-spoof Status

* -100 Invalid Image
* -5 Greyscale Image
* -4 Invalid Face
* -2 Mobile phone detected
* -1 No Face Detected
* 0 Real
* 1 Spoof

## Example App

The app serves as an illustrative application to understand the capabilities of the `Cryptonets` SDK. 

### Example app installation

1. Install [TestFlight](https://apps.apple.com/app/testflight/id899247664) app on your device.
2. Open the [CryptonetDemo](https://testflight.apple.com/join/LHZIJsGC) link SDK on your device.
3. Tap the `Accept` and `Install` buttons.
