/** @file privid_api_c.h
 * This cpp file is the api header file exposing PrivateId Face Module API
  * COPYRIGHT NOTICE: (c) 2023 Private Identity.  All rights reserved.
 */

#ifndef PRIV_ID_G_API_C_H_
#define PRIV_ID_G_API_C_H_

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif // #ifdef __EMSCRIPTEN__

#ifdef __EMSCRIPTEN__
#define PRIVID_API_ATTRIB EMSCRIPTEN_KEEPALIVE
#else // #ifdef __EMSCRIPTEN__
#if (defined(__linux__) || defined(__CYGWIN__) || defined(__clang__))
#define PRIVID_API_ATTRIB __attribute__((visibility("default")))
#else
#define PRIVID_API_ATTRIB __declspec(dllexport)
#endif // (defined(__linux__) || defined(__CYGWIN__))
#endif // #ifdef __EMSCRIPTEN__

#ifdef __cplusplus
    #include <cstdint>
    extern "C" {
#else
    typedef unsigned char uint8_t;
    #include <stdbool.h>
    #include <stdint.h>
#endif // #ifdef __cplusplus

/**
* \brief Initialize the library with the models loading directory. Should be called only once before first session initalizaiton.
* @param models_directory Full path for the driectory with model `.data` files for loading. Should be writable if URL loading is used.
* @param models_directory_length The size of the `models_directory` buffer without the ending null character '\0'
*/
PRIVID_API_ATTRIB void privid_initialize_lib(
    const char* models_directory, const int models_directory_length);

/**
* \brief Creates a new session and returns a pointers to it. A session is required to perform any operation.
* The session must be cleared once there are no more operations be to performed (i.e during application closure)
* by calling #privid_deinitialize_session.
*
* @param settings_buffer A buffer containing the JSON string representation of the privid.oidc.core.session_creation_settings message
* this message contains all required data for initializing the session correctly. If these settings are missing or invalid then
* a session will no be created and false is returned.
* @param settings_length  The size of the 'settings_buffer' buffer without the ending null character '\0'
* @param[out] session_ptr_out The initialized session pointer is returned in this argument.
* @return True for successful initialization false otherwise.
*/
PRIVID_API_ATTRIB bool privid_initialize_session(const char* settings_buffer, const unsigned int settings_length, void** session_ptr_out);

/**
* \brief  Changes the default configuration values for the session. Currently we support an additional configuration for web settings.
* 
* @param session_ptr  session pointer obtained from #privid_initialize_session.
* @param configuration_type currently we support only web with teh code 1.
*
*/
PRIVID_API_ATTRIB void privid_set_default_configuration(void* session_ptr, int configuration_type);

/**
* \brief Un-initialize the session which was already initialized using #privid_initialize_session.
* 
* @param session_ptr session pointer obtained from #privid_initialize_session.
*
*/
PRIVID_API_ATTRIB void privid_deinitialize_session(void *session_ptr);
/**
* \brief Free  char, uchar or uint8_t array buffers allocated by library API calls (for output buffers for example). 
* 
* @param buffer char/unsigned char/uint8_t buffer to free.  
*
*/
PRIVID_API_ATTRIB void privid_free_char_buffer(char *buffer);
/**
* \brief Set session configuration 
* 
* @param session_ptr session pointer obtained from #privid_initialize_session.
* @param user_config Json configuration buffer.
* @param user_config_length Length of the  Json configuration buffer.    
*/
PRIVID_API_ATTRIB bool privid_set_configuration(void *session_ptr, const char *user_config,const int user_config_length);
/**
* \brief Set the cycling threshold of Billing records 
* 
* @param session_ptr session pointer obtained from #privid_initialize_session.
* @param billing_config Billing configuration JSON - map between operation names and desired thresholds.
* @param billing_config_length Billing configuration JONS length (without the ending zero character).
*/
PRIVID_API_ATTRIB bool privid_set_billing_record_threshold(
        void *session_ptr, const char *billing_config,
        const int billing_config_length);
/**
* \brief Validate a face image. 
* The returned API result is name *faces* and its type is #privid.messages.operation_results.FacesValidationData (see operation results proto messages definition).
* @param session_ptr session pointer obtained from #privid_initialize_session.
* @param image_bytes Input image buffer to validate. 
* @param image_width Width of the input image.
* @param image_height Height of the input image.
* @param user_config Json configuration buffer.
* @param user_config_length Length of the  Json configuration buffer.
* @param[out] result_out Output buffer which contains the result of the operation (see #privid.messages.operation_results.ApiResult).
* The API will allocate desired memory to this buffer, it is the responsibility of caller to free the memory after the call using #privid_free_char_buffer.
* NULL is a valid input if caller does not require the output.
* @param[out] result_out_length Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
* @return If the operation is executed correctly, a sequential operation id is returned that is (>0),
* otherwise  a negative value is returned. The reason for the failure of the execution of the API is indicated by call_status member of the
* #privid.messages.operation_results.ApiResult JSON returned in the result_out buffer.
*/
PRIVID_API_ATTRIB int32_t privid_validate(
        void *session_ptr, const uint8_t* image_bytes, const int image_width,
        const int image_height,const char *user_config, const int user_config_length,
        char **result_out, int *result_out_length);

/**  
* \brief Estimate age of face in the input image 
* 
* @param session_ptr session pointer obtained from #privid_initialize_session.
* @param image_bytes Input image buffer to estimate age 
* @param image_width Width of the input image
* @param image_height Height of the input image
* @param user_config Json configuration buffer.
* @param user_config_length Length of the  Json configuration buffer.
* @param[out] result_out Output buffer which contains the result of the operation (see #privid.messages.operation_results.ApiResult).
* The API will allocate desired memory to this buffer, it is the responsibility of caller to free the memory after the call using #privid_free_char_buffer.
* NULL is a valid input if caller does not require the output.
* @param[out] result_out_length Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
* @return If the operation is executed correctly, a sequential operation id is returned that is (>0),
* otherwise  a negative value is returned. The reason for the failure of the execution of the API is indicated by call_status member of the
* #privid.messages.operation_results.ApiResult JSON returned in the result_out buffer.
*/
PRIVID_API_ATTRIB int32_t privid_estimate_age(
        void *session_ptr, const uint8_t* image_bytes, const int image_width,
        const int image_height,const char *user_config, const int user_config_length,
        char **result_out, int *result_out_length);

/**
* \brief Perform 1FA Enroll Operation 
* 
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer. 
* @param *image_bytes:             Input images buffer
* @param image_count:               Number of images in the input images buffer
* @param image_size:                Size of one image in the input images buffer
* @param image_width:               Width of the one input image . In case of multiple images, all images should have this
*                                   width
* @param image_height:              Height of the one input image.
* @param[out] **best_input_out      Returns cropped document image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *best_input_length    Length of the cropped document image buffer;
* @param[out] **result_out:         Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using #privid_free_char_buffer API
*                                   NULL is a valid input if caller does not require the output
* @param[out] *result_out_length:        Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
*
* @return                           In case of success a positive value (>0) is retuned, if a transaction was performed then the returned value 
*                                   corresponds the transaction id (strictly positive value).
*                                   In case of failure a negative value is returned indicating the reason for the failure. 
*                                   It shall be noted that. If the enroll operation was performed, then the enroll operation result
*                                   shall be returned in operation_result_out output buffer.
*
*/

PRIVID_API_ATTRIB int32_t privid_enroll_onefa(
        void *session_ptr, const char *user_config, const int user_config_length,
        const uint8_t * image_bytes, const int image_count, const int image_size,
        const int image_width, const int image_height,
        uint8_t** best_input_out, int *best_input_length,
        char **result_out, int *result_out_length);
 
/**
* \brief Perform 1FA Predict Operation 
* 
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer. 
* @param *input_images:             Input images buffer
* @param image_count:               Number of images in the input images buffer
* @param image_size:                Size of one image in the input images buffer
* @param image_width:               Width of the one input image . In case of multiple images, all images should have this
*                                   width
* @param image_height:              Height of the one input image.
* @param[out] **result_out:              Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using privid_free_char_buffer() API
*                                   NULL is a valid input if caller does not require the output
* @param[out] *result_out_length:        Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
*
* @return                           Status of the execution of the API. >0 for success and transaction id is returned which, 
*                                   can be used to track concurrent calls, otherwise a negative value is returned
*                                   indicating the reason for the failure of the execution of the API. It shall be noted that
*                                   this status does not represent the status of the Enroll operation itself. If the enroll
*                                   operation API is executed successfully (i.e >0 returned), then the enroll operation result
*                                   shall be returned in operation_result_out output buffer
*
*/

PRIVID_API_ATTRIB int32_t privid_face_predict_onefa(
        void *session_ptr, const char *user_config, const int user_config_length,
        const uint8_t *input_images, const int image_count, const int image_size,
        const int image_width, const int image_height,
        char **result_out, int *result_out_length);
 
/**
* \brief Delete a user 
* 
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_conf:                User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param conf_len:                  Length of the configuration buffer. 
* @param *puid:                     User's puid to delete 
* @param puid_length:               Length of the puid input 
* @param[out] **operation_result_out:    Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using privid_free_char_buffer() API
*                                   NULL is a valid input if caller does not require the output
* @param[out] *operation_result_out_len: Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
*
* @return                           Status of the execution of the API. >0 for success and transaction id is returned which, 
*                                   can be used to track concurrent calls, otherwise a negative value is returned
*                                   indicating the reason for the failure of the execution of the API. It shall be noted that
*                                   this status does not represent the status of the delete operation itself. If the delete 
*                                   operation API is executed successfully (i.e >0 returned), then the delete operation result
*                                   shall be returned in operation_result_out output buffer
*
*/
PRIVID_API_ATTRIB int32_t privid_user_delete(
        void *session_ptr, const char *user_conf, const int conf_len,
        const char *puid, const int puid_length,
        char **operation_result_out, int *operation_result_out_len);

/**
* \brief	Scans the face from front page of the license.
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer. 
* @param p_buffer_image_in          Pointer to image buffer
* @param image_width                Width of the image
* @param image_height               Height of the image
* @param[out] **cropped_doc_out     Returns cropped document image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *cropped_doc_length   Length of the cropped document image buffer;
* @param[out] **cropped_face_out    Returns cropped face image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *cropped_face_length  Length of the cropped face image buffer;
* @param[out] **result_out:         Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using FHE_free_api_memory API.
*                                   NULL is a valid input if caller does not require the output.
* @param[out] *result_out_length:   Size of the output buffer result_out. NULL is a valid input if caller does not require the output
*/
PRIVID_API_ATTRIB int32_t privid_doc_scan_face(
        void *session_ptr, const char *user_config, const int user_config_length,
        const uint8_t* p_buffer_image_in, const int image_width, const int image_height,
        uint8_t** cropped_doc_out, int *cropped_doc_length, 
        uint8_t **cropped_face_out, int *cropped_face_length,
        char** result_out, int* result_out_length);

/**
* \brief	Scans the barcode from back page of the license.
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:                  Length of the configuration buffer. 
* @param p_buffer_image_in          Pointer to image buffer
* @param image_width                Width of the image
* @param image_height               Height of the image
* @param[out] **cropped_doc_out     Returns cropped document image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *cropped_doc_length   Length of the cropped document image buffer;
* @param[out] **cropped_barcode_out Returns cropped barcode image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *cropped_barcode_length    Length of the cropped barcode image buffer;
* @param[out] **result_out:         Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using FHE_free_api_memory API.
*                                   NULL is a valid input if caller does not require the output.
* @param[out] *result_out_length:   Size of the output buffer result_out. NULL is a valid input if caller does not require the output
*/
PRIVID_API_ATTRIB int32_t privid_doc_scan_barcode(
        void *session_ptr, const char *user_config, const int user_config_length,
        const uint8_t* p_buffer_image_in, const int image_width, const int image_height,
        uint8_t** cropped_doc_out, int *cropped_doc_length, 
        uint8_t** cropped_barcode_out, int *cropped_barcode_length,
        char** result_out, int* result_out_length);

/**
* \brief                            Compare two files of different sizes
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param fudge_factor:              Allowance for poor images
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter.
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer.
* @param *p_buffer_files_A:         First input image byte array
* @param im_size_A:                 Size of the imageA
* @param im_width_A:                Width of the imageA
* @param im_height_A:               Height of the imageA
* @param *p_buffer_files_B:         Second input image byte array
* @param im_size_B:                 Size of the imageB
* @param im_width_B:                Width of the imageB
* @param im_height_B:               Height of the imageB
* @param[out] **result_out:              Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of
*                                   caller to free the memory after the call using FHE_free_api_memory API.
*                                   NULL is a valid input if caller does not require the output.
* @param[out] *result_out_length:        Size of the output buffer result_out. NULL is a valid input if caller does not require the output
*
* @return                           Status of the execution of the API. >0 for success and transaction id is returned which,
*                                   can be used to track concurrent calls, otherwise a negative value is returned
*                                   indicating the reason for the failure of the execution of the API. It shall be noted that
*                                   this status does not represent the status of the Enroll operation itself. If the enroll
*                                   operation API is executed successfully (i.e >0 returned), then the enroll operation result
*                                   shall be returned in operation_result_out output buffer
*
*/
PRIVID_API_ATTRIB int32_t privid_face_compare_files(
        void* session_ptr, float fudge_factor,
        const char* user_config, int user_config_length,
        const uint8_t* p_buffer_files_A, int im_size_A, int im_width_A, int im_height_A,
        const uint8_t* p_buffer_files_B, int im_size_B, int im_width_B, int im_height_B,
        char** result_out, int* result_out_length);

/**
* \brief                            Compare two files of different sizes
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter.
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer.
* @param *p_buffer_files_A:         First input image byte array
* @param im_size_A:                 Size of the imageA
* @param im_width_A:                Width of the imageA
* @param im_height_A:               Height of the imageA
* @param *p_buffer_files_B:         Second input image byte array
* @param im_size_B:                 Size of the imageB
* @param im_width_B:                Width of the imageB
* @param im_height_B:               Height of the imageB
* @param **result_out:              Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of
*                                   caller to free the memory after the call using FHE_free_api_memory API.
*                                   NULL is a valid input if caller does not require the output.
* @param *result_out_length:        Size of the output buffer result_out. NULL is a valid input if caller does not require the output
*
* @return                           Status of the execution of the API. >0 for success and transaction id is returned which,
*                                   can be used to track concurrent calls, otherwise a negative value is returned
*                                   indicating the reason for the failure of the execution of the API. It shall be noted that
*                                   this status does not represent the status of the Enroll operation itself. If the enroll
*                                   operation API is executed successfully (i.e >0 returned), then the enroll operation result
*                                   shall be returned in operation_result_out output buffer
*
*/
PRIVID_API_ATTRIB int32_t privid_face_compare_local(
        void* session_ptr, const char* user_config, int user_config_length,
        const uint8_t* p_buffer_files_A, int im_size_A, int im_width_A, int im_height_A,
        const uint8_t* p_buffer_files_B, int im_size_B, int im_width_B, int im_height_B,
        char** result_out, int* result_out_length); 

/**
* \brief Perform Face ISO Operation 
* 
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *image_bytes:              Input images buffer
* @param image_width:               Width of the one input image . In case of multiple images, all images should have this
*                                   width
* @param image_height:              Height of the one input image.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter. 
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer. 
* @param[out] **result_out:              Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of 
*                                   caller to free the memory after the call using privid_free_char_buffer() API
*                                   NULL is a valid input if caller does not require the output
* @param[out] *result_out_length:        Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
* @param[out] **output_iso_image_bytes:  In case of successful operation, cropped image as per Face ISO specification will be returned
* @param[out] *output_iso_image_bytes_length:  Length of the cropped Face ISO image
*
* @return                           Status of the execution of the API. >0 for success and transaction id is returned which, 
*                                   can be used to track concurrent calls, otherwise a negative value is returned
*                                   indicating the reason for the failure of the execution of the API. It shall be noted that
*                                   this status does not represent the status of the Enroll operation itself. If the enroll
*                                   operation API is executed successfully (i.e >0 returned), then the enroll operation result
*                                   shall be returned in operation_result_out output buffer
*/
PRIVID_API_ATTRIB int32_t privid_face_iso(
        void *session_ptr, const uint8_t *image_bytes, const int image_width, const int image_height,
        const char *user_config, const int user_config_length, char **result_out, int *result_out_length,
        uint8_t** output_iso_image_bytes, int* output_iso_image_bytes_length);

/**
* \brief call anti-spoofing function
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *image_bytes:              Input image buffer
* @param image_width:               Width of the input image
* @param image_height:              Height of the input image
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter.
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer.
* @param[out] *faces_count_out:     Detected faces count.
* @param[out] **anti_spoofing_vector_out: Anti spoofing vector data.
* @param[out] **anti_spoofing_vector_out_length: Anti spoofing vector data size.
* @param[out] **result_out:         Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of
*                                   caller to free the memory after the call using privid_free_char_buffer() API
*                                   NULL is a valid input if caller does not require the output
* @param[out] *result_out_length:   Size of the output buffer result_out. NULL is a valid input if caller
*                                   does not require the output.
*/
PRIVID_API_ATTRIB int32_t privid_anti_spoofing(
    void* session_ptr, const uint8_t* image_bytes, const int image_width,
    const int image_height, const char* user_config, const int user_config_length,
    char** result_out, int* result_out_length);


/**
 * \brief return the libml version string
 * \param versionString pointer receiving the version string
 * \param versionStringLen the length of the returned string
 */
PRIVID_API_ATTRIB void privid_get_libml_version(char **versionString, int *versionStringLen);

/**
 * \brief Compare a cropped document image and a face image and return a serialized :privid_results_compare with 
 * a confidence score formatted as a percentage.
 * If either faces are invalid we set the result status to face not detected error.
 * Both images must be in RGB format.
 * @param *session_ptr session pointer obtained from #privid_initialize_session.
 * \param user_config User configuration in the JSON parameters. Any configuration parameter provided
 *                                   in the configuration JSON shall overwrite the default value of the parameter. 
 *                                   Only provided configuration parameter shall be impacted, rest will remain to default
 *                                   This can also be null, in such case, default configuration shall be used
 * \param user_config_length Length of the config buffer
 * \param p_doc_image_in  Buffer of a document image (DL etc..) containing a mugshot, the image is already 
 *                        cropped to the contour of the document
 * \param doc_image_width Width of the document image 
 * \param doc_image_height Height of the document image 
 * \param p_face_image_in  Buffer of the face image 
 * \param face_image_width Width of the face image
 * \param face_image_height Height of the face image
 * \param cropped_mughshot_out Buffer of the ISO cropped image of the face found in the mugshot
 * \param cropped_mughshot_length Length  of the buffer of the ISO cropped image of the face found in the mugshot
 * \param cropped_face_out  Buffer of the ISO cropped image of the face found in the input face image
 * \param cropped_face_length Length  of the buffer of the ISO cropped image of the face found in the input face image
 * \param result_out Buffer of the output json result string
 * \param result_out_length Length of buffer of the output json result string, the json is a serialization of ::privid_results_compare
 * Please note that the confidence score returned is a percentage and not a ratio. 
 * \return The transaction id (strictly positive integer) if the operation is successful, otherwise 0
 */

PRIVID_API_ATTRIB int32_t privid_compare_mugshot_and_face(void* session_ptr, const char* user_config, const int user_config_length,
                            const uint8_t* p_doc_image_in, const int doc_image_width, const int doc_image_height,
                            const uint8_t* p_face_image_in, const int face_image_width, const int face_image_height,
                            uint8_t** cropped_mughshot_out, int* cropped_mughshot_length,
                            uint8_t** cropped_face_out, int* cropped_face_length,
                            char** result_out, int* result_out_length);


/**
 * \brief Compare a cropped document image and a face image using the face encrypted embeddings 
 * captured during an enroll. It bahave exactly as as #privid_compare_mugshot_and_face.
 * If the mugshot face is invalid we set the result status to face not detected error.
 * The document images must be in RGB format.
 * @param *session_ptr session pointer obtained from #privid_initialize_session.
 * \param user_config User configuration in the JSON parameters. Any configuration parameter provided
 *                                   in the configuration JSON shall overwrite the default value of the parameter.
 *                                   Only provided configuration parameter shall be impacted, rest will remain to default
 *                                   This can also be null, in such case, default configuration shall be used
 * \param user_config_length Length of the config buffer
 * \param p_doc_image_in  Buffer of a document image (DL etc..) containing a mugshot, the image is already
 *                        cropped to the contour of the document
 * \param doc_image_width Width of the document image
 * \param doc_image_height Height of the document image
 * \param cropped_mughshot_out Buffer of the ISO cropped image of the face found in the mugshot
 * \param cropped_mughshot_length Length  of the buffer of the ISO cropped image of the face found in the mugshot
 * \param encrypted_embeddings string buffer representing the encrypted embedding to use for the compare operation.
 * \param encrypted_embeddings_size Length  of the 'encrypted_embeddings' buffer.
 * \param result_out Buffer of the output json result string
 * \param result_out_length Length of buffer of the output json result string, the json is a serialization of ::privid_results_compare
 * Please note that the confidence score returned is a percentage and not a ratio.
 * \return The transaction id (strictly positive integer) if the operation is successful, otherwise 0
 */
PRIVID_API_ATTRIB int32_t privid_compare_mugshot_and_embeddings(void* session_ptr, const char* user_config, const int user_config_length,
    const uint8_t* p_doc_image_in, const int doc_image_width, const int doc_image_height,
    uint8_t** cropped_mughshot_out, int* cropped_mughshot_length,
    const char* encrypted_embeddings, int encrypted_embeddings_size,
    char** result_out, int* result_out_length);

/**
* \brief	Scans the a document that dos not contain a face
*
* @param *session_ptr session pointer obtained from #privid_initialize_session.
* @param *user_config:              User configuration in the JSON parameters. Any configuration parameter provided
*                                   in the configuration JSON shall overwrite the default value of the parameter.
*                                   Only provided configuration parameter shall be impacted, rest will remain to default
*                                   This can also be null, in such case, default configuration shall be used
* @param user_config_length:        Length of the configuration buffer.
* @param p_buffer_image_in          Pointer to image buffer
* @param image_width                Width of the image
* @param image_height               Height of the image
* @param[out] **cropped_doc_out     Returns cropped document image if not null. The caller will have to de-allocate memory after using it.
* @param[out] *cropped_doc_length   Length of the cropped document image buffer;
* @param[out] **result_out:         Output buffer which contains the result of the operation. The API will
*                                   allocate desired memory to this buffer, it is the responsibility of
*                                   caller to free the memory after the call using FHE_free_api_memory API.
*                                   NULL is a valid input if caller does not require the output.
* @param[out] *result_out_length:   Size of the output buffer result_out. NULL is a valid input if caller does not require the output
* @remark : the billing code operation used here is privid_operation_tags::doc_front_tag , but the call back operation tag is "scan_doc_with_no_face"
*
*/
PRIVID_API_ATTRIB int32_t privid_scan_document_with_no_face(
        void *session_ptr, const char *user_config, const int user_config_length,
        const uint8_t* p_buffer_image_in, const int image_width, const int image_height,
        uint8_t** cropped_doc_out, int *cropped_doc_length,
        char** result_out, int* result_out_length);


/**
 * \brief gets the version of the library/wasm
*/
PRIVID_API_ATTRIB const char* privid_get_version(void);

#ifdef __cplusplus
}
#endif

#endif // PRIV_ID_API_C_H_
