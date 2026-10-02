import 'package:flutter/material.dart';

// Masking Config
bool isMaskingEnabledGlobal = true;

// Dialog Config
Color defaultDialogConfirmColorGlobal = Colors.indigo;
Color defaultDialogCancelColorGlobal = Colors.grey.shade600;
Color defaultDialogInfoColorGlobal = Colors.teal;
BorderRadius defaultDialogBorderRadiusGlobal = BorderRadius.circular(24);

// Pagination Config
int defaultPaginationPageSizeGlobal = 20;
String defaultPaginationErrorTitleGlobal = 'Something went wrong';
String defaultPaginationErrorMessageGlobal = 'We could not load the data. Please check your connection and try again.';
String defaultPaginationRetryTextGlobal = 'Retry';
String defaultPaginationCancelTextGlobal = 'Cancel';
String defaultPaginationEmptyTitleGlobal = 'Nothing here yet';
double defaultPaginationPrefetchThresholdGlobal = 200;
String defaultPaginationTimeoutMessageGlobal = 'The request took too long to respond. Please try again.';

// Button Config
double defaultButtonBorderRadiusGlobal = 12;
double defaultButtonHeightSmallGlobal = 38;
double defaultButtonHeightMediumGlobal = 48;
double defaultButtonHeightLargeGlobal = 56;

// Text Field Config
double defaultFieldBorderRadiusGlobal = 12;
String defaultFieldRequiredMessageGlobal = 'This field is required';
String defaultFieldInvalidEmailMessageGlobal = 'Enter a valid email address';
String defaultFieldInvalidPhoneMessageGlobal = 'Enter a valid phone number';
String defaultFieldInvalidCnicMessageGlobal = 'Enter a valid CNIC (00000-0000000-0)';

// Bottom Sheet Config
double defaultSheetBorderRadiusGlobal = 24;
String defaultSheetCancelTextGlobal = 'Cancel';

// Alert Banner Config
Color defaultAlertSuccessColorGlobal = const Color(0xFF2E7D32);
Color defaultAlertErrorColorGlobal = const Color(0xFFC62828);
Color defaultAlertWarningColorGlobal = const Color(0xFFEF6C00);
Color defaultAlertInfoColorGlobal = const Color(0xFF1565C0);

// Async Builder Config
String defaultAsyncErrorTitleGlobal = 'Something went wrong';
String defaultAsyncErrorMessageGlobal = 'We could not load the data. Please check your connection and try again.';
String defaultAsyncRetryTextGlobal = 'Retry';
String defaultAsyncEmptyTitleGlobal = 'Nothing here yet';

// Connectivity Config
String defaultOfflineMessageGlobal = 'No internet connection';
String defaultOnlineMessageGlobal = 'Back online';

// Image Picker Sheet Config
String defaultImagePickerTitleGlobal = 'Choose a photo';
String defaultImagePickerCameraTextGlobal = 'Take a photo';
String defaultImagePickerGalleryTextGlobal = 'Choose from gallery';
String defaultImagePickerRemoveTextGlobal = 'Remove photo';
