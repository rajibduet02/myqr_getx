import 'emv_spec.dart';

class EMVCOSpecList {
  List<EMVSpec> SpecList = <EMVSpec>[];
  List<EMVSpec> AdditionalSpecList = <EMVSpec>[];
  List<EMVSpec> LanguageTemplate = <EMVSpec>[];
  List<EMVSpec> MerchantAccountInfo = <EMVSpec>[];
  List<EMVSpec> UnreservedTemplates = <EMVSpec>[];

  EMVCOSpecList() {
    if (SpecList.length <= 0) {
      //00-Payload Format Indicator
      SpecList.insert(
          0,
          EMVSpec(
              Id: '00',
              Name: "Payload Format Indicator",
              Format: "N",
              Length: "02",
              Presence: "M",
              Comments:
                  "Defines the version of the QR Code template and hence the conventions on the identifiers, lengths, and values.\n\nIn this version of the specification, the Payload Format Indicator has the value '01'."));
      //01-Point of Initiation Method
      SpecList.insert(
          1,
          EMVSpec(
              Id: '01',
              Name: "Point of Initiation Method",
              Format: "N",
              Length: "02",
              Presence: "O",
              Comments:
                  "Identifies the communication technology (here QR Code) and whether the data is static or dynamic.\n\nThe Point of Initiation Method has a value of '11' for static QR Codes and a value of '12' for dynamic QR Codes.\n\nThe value of '11' is used when the same QR Code is shown for more than one transaction.\n\nThe value of '12' is used when a new QR Code is shown for each transaction."));
      //02-RESERVED BY VISA
      SpecList.insert(
          2,
          EMVSpec(
              Id: '02',
              Name: "RESERVED BY VISA",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "02-03: Visa\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //03-RESERVED BY VISA
      SpecList.insert(
          3,
          EMVSpec(
              Id: '03',
              Name: "RESERVED BY VISA",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "02-03: Visa\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));

      //04-RESERVED BY MASTER
      SpecList.insert(
          4,
          EMVSpec(
              Id: '04',
              Name: "RESERVED BY MASTER",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "04-05 MASTER\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //05-RESERVED BY MASTER
      SpecList.insert(
          5,
          EMVSpec(
              Id: '05',
              Name: "RESERVED BY MASTER",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "04-05 Master\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //06-RESERVED BY EMVCO
      SpecList.insert(
          6,
          EMVSpec(
              Id: '06',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "6-8 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //07-RESERVED BY EMVCO
      SpecList.insert(
          7,
          EMVSpec(
              Id: '07',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "6-8 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //08-RESERVED BY EMVCO
      SpecList.insert(
          8,
          EMVSpec(
              Id: '08',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "6-8 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //09-RESERVED BY DISCOVER
      SpecList.insert(
          9,
          EMVSpec(
              Id: '09',
              Name: "RESERVED BY DISCOVER",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "09-10 DISCOVER\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));

      //10-RESERVED BY DISCOVER
      SpecList.insert(
          10,
          EMVSpec(
              Id: '10',
              Name: "RESERVED BY DISCOVER",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "09-10 DISCOVER\\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //11-RESERVED BY AMEX
      SpecList.insert(
          11,
          EMVSpec(
              Id: '11',
              Name: "RESERVED BY AMEX",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "11-12 AMEX\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //12-RESERVED BY AMEX
      SpecList.insert(
          12,
          EMVSpec(
              Id: '12',
              Name: "RESERVED BY AMEX",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "11-12 AMEX\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //13-RESERVED BY JCB

      SpecList.insert(
          13,
          EMVSpec(
              Id: '13',
              Name: "RESERVED BY JCB",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "13-14 JCB\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //14-RESERVED BY JCB
      SpecList.insert(
          14,
          EMVSpec(
              Id: '14',
              Name: "RESERVED BY JCB",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "13-14 JCB\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //15-RESERVED BY UNION PAY
      SpecList.insert(
          15,
          EMVSpec(
              Id: '15',
              Name: "RESREVED BY UNION PAY",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "15-16 UNION PAY\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //15-RESERVED BY UNION PAY
      SpecList.insert(
          16,
          EMVSpec(
              Id: '16',
              Name: "RESREVED BY UNION PAY",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "15-16 UNION PAY\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //17-25 RESERVED BY EMVCO
      SpecList.insert(
          17,
          EMVSpec(
              Id: '17',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          18,
          EMVSpec(
              Id: '18',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          19,
          EMVSpec(
              Id: '19',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          20,
          EMVSpec(
              Id: '20',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          21,
          EMVSpec(
              Id: '21',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          22,
          EMVSpec(
              Id: '22',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          23,
          EMVSpec(
              Id: '23',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          24,
          EMVSpec(
              Id: '24',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      SpecList.insert(
          25,
          EMVSpec(
              Id: '25',
              Name: "RESERVED BY EMVCO",
              Format: "ANS",
              Length: "99",
              Presence: "M",
              Comments:
                  "17-25 RESERVED BY EMVCO\n\nIdentifies the merchant.\n\nThe format and value are unique and specific to a payment system and several values may be included in the QR Code."));
      //26-51 RESERVED BY ADDITIONAL PAYMENT NETWORK
      for (int i = 26; i <= 51; i++) {
        SpecList.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "RESERVED FOR ADDITIONAL PAYEMENT NETWORK",
                Format: "N",
                Length: "99",
                Presence: "M",
                Comments: "RESERVED FOR ADDITIONAL PAYEMENT NETWORK"));
      }

      SpecList.insert(
          52,
          EMVSpec(
              Id: '52',
              Name: "Merchant Category Code",
              Format: "N",
              Length: "04",
              Presence: "M",
              Comments:
                  "Shall contain an MCC as defined by [ISO 18245].This MCC should indicate the Merchant Category Code of the merchant and is assigned by the Acquirer."));
      SpecList.insert(
          53,
          EMVSpec(
              Id: '53',
              Name: "Transaction Currency",
              Format: "N",
              Length: "03",
              Presence: "M",
              Comments:
                  "The Transaction Currency shall conform to [ISO 4217] and shall contain the 3-digit numeric representation of the currency. For example, USD is represented by the value '840'.\nThe value should indicate the transaction currency in which the merchant transacts."));
      SpecList.insert(
          54,
          EMVSpec(
              Id: '54',
              Name: "Transaction Amount",
              Format: "ANS",
              Length: "13",
              Presence: "C",
              Comments:
                  "If present, the Transaction Amount shall be different from zero, shall only include (numeric) digits '0' to '9' and may contain a single '.' character as the decimal mark. When the amount includes decimals, the '.' character shall be used to separate the decimals from the integer value and the '.' character may be present even if there are no decimals.\nThe number of digits after the decimal mark should align with the currency exponent associated to the currency code defined in [ISO 4217].\nThe above describes the only acceptable format for the Transaction Amount. It cannot contain any other characters (for instance, no space character can be used to separate thousands).\nThe following are examples of valid Transaction Amounts: '98.73', '98' and '98.'. The following are NOT valid Transaction Amounts: '98,73' and '3 705'.\nThe Transaction Amount shall not be included if the mobile application should prompt the consumer to enter the amount to be paid to the Merchant."));
      SpecList.insert(
          55,
          EMVSpec(
              Id: '55',
              Name: "Tip or Convenience Indicator",
              Format: "N",
              Length: "02",
              Presence: "O",
              Comments:
                  "If present, the Tip or Convenience Indicator shall contain a value of '01', '02' or '03'. All other values are RFU.\n- A value of '01' shall be used if the mobile application should prompt the consumer to enter a tip to be paid to the merchant.\n- A value of '02' shall be used to indicate inclusion of the data object Value of Convenience Fee Fixed (ID '56').\n- A value of '03' shall be used to indicate inclusion of the data object Value of Convenience Fee Percentage (ID '57').\nNote that even if the Transaction Amount is not present in the QR Code, this data object may still be present."));
      SpecList.insert(
          56,
          EMVSpec(
              Id: '56',
              Name: "Value of convenience fee Fixed",
              Format: "ANS",
              Length: "13",
              Presence: "C",
              Comments:
                  "The Value of Convenience Fee Fixed shall be present and different from zero if the data object Tip or Convenience Indicator (ID '55') is present with a value of '02'. Otherwise this data object shall be absent.\nIf present, the Value of Convenience Fee Fixed shall only include (numeric) digits '0' to '9' and may contain a single '.' character as the decimal mark.\nWhen the Value of the Convenience Fee Fixed includes decimals, the '.' character shall be used to separate the decimals from the integer value.\nThe '.' character may be present even if there are no decimals.\nThe number of digits after the decimal mark should align with the currency exponent associated to the currency code defined in [ISO 4217].\n\nThe above describes the only acceptable format for the Value of Convenience Fee Fixed. It cannot contain any other characters (for instance, no space character can be used to separate thousands)."));
      SpecList.insert(
          57,
          EMVSpec(
              Id: '57',
              Name: "Value of convenience fee Percentage",
              Format: "ANS",
              Length: "05",
              Presence: "C",
              Comments:
                  "The Value of Convenience Fee Percentage shall be present if the data object Tip or Convenience Indicator (ID '55') is present with a value of '03' and only values between '00.01' and '99.99' shall be used. Otherwise this data object shall be absent.\nIf present, the Value of Convenience Fee Percentage shall only include (numeric) digits '0' to '9' and may contain a single '.' character as the decimal mark.\nWhen the Value of the Convenience Fee Percentage includes decimals, the '.' character shall be used to separate the decimals from the integer value and the '.' character may be present even if there are no decimals.\n\nThe Value of Convenience Fee Percentage shall not contain any other characters.\nFor example, the “%” character must not be included.\nThe above describes the only acceptable format for the Value of Convenience Fee Percentage."));
      SpecList.insert(
          58,
          EMVSpec(
              Id: '58',
              Name: "Country Code",
              Format: "ANS",
              Length: "02",
              Presence: "M",
              Comments:
                  "Indicates the country of the merchant acceptance device.\nA 2-character alpha value, as defined by [ISO 3166-1 alpha 2] and assigned by the Acquirer. The country may be displayed to the consumer by the mobile application when processing the transaction."));
      SpecList.insert(
          59,
          EMVSpec(
              Id: '59',
              Name: "Merchant Name",
              Format: "ANS",
              Length: "25",
              Presence: "M",
              Comments:
                  "The “doing business as” name for the merchant, recognizable to the consumer. This name may be displayed to the consumer by the mobile application when processing the transaction."));
      SpecList.insert(
          60,
          EMVSpec(
              Id: '60',
              Name: "Merchant City",
              Format: "ANS",
              Length: "15",
              Presence: "M",
              Comments:
                  "City of operations for the merchant. This name may be displayed to the consumer by the mobile application when processing the transaction."));
      SpecList.insert(
          61,
          EMVSpec(
              Id: '61',
              Name: "Postal Code",
              Format: "ANS",
              Length: "10",
              Presence: "O",
              Comments:
                  "Zip code or Pin code or Postal code of the merchant. If present, this value may be displayed to the consumer by the mobile application when processing the transaction."));
      SpecList.insert(
          62,
          EMVSpec(
              Id: '62',
              Name: "Additional Data Field Template",
              Format: "S",
              Length: "99",
              Presence: "O",
              Comments:
                  "The Additional Data Field Template includes information that may be provided by the Merchant or may be populated by the mobile application to enable or facilitate certain use cases.\n\nFor the list of data objects that can be included in this template\nEach of the data objects with IDs '01' to '08' in Table 3.7 can be used in two ways: either the merchant can provide both the ID and its meaningful value or the merchant can include the ID with a special value to have the mobile application prompt the consumer to input this information.\nTo prompt the consumer for one or more of these values, the merchant includes the respective IDs in this template each with a length of '03' and with a value equal to '***'."));
      SpecList.insert(
          63,
          EMVSpec(
              Id: '63',
              Name: "CRC (Cyclic Redundancy Check)",
              Format: "ANS",
              Length: "04",
              Presence: "M",
              Comments:
                  "The checksum shall be calculated according to [ISO/IEC 13239] using the polynomial '1021' (hex) and initial value 'FFFF' (hex). The data over which the checksum is calculated shall cover all data objects, including their ID, Length and Value, to be included in the QR Code, in their respective order, as well as the ID and Length of the CRC itself (but excluding its Value).\nFollowing the calculation of the checksum, the resulting 2-byte hexadecimal value shall be encoded as a 4-character Alphanumeric Special value by converting each nibble to an Alphanumeric Special character.\n\nExample: a CRC with a two-byte hexadecimal value of '007B' is included in the QR Code as '6304007B''."));
      SpecList.insert(
          64,
          EMVSpec(
              Id: '64',
              Name: "Merchant Information - Language Template",
              Format: "S",
              Length: "99",
              Presence: "O",
              Comments:
                  "The Merchant Information— Language Template includes merchant information in an alternate language and may use a character set different from the Common Character Set. It provides an alternative to the merchant information under the root.\n\For the list of data objects that can be included in this template, please refer to Table 3.8."));

      for (int i = 65; i <= 79; i++) {
        SpecList.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "RFU (Reserved for Future Use) for EMVCo",
                Format: "S",
                Length: "99",
                Presence: "O",
                Comments: "Data objects reserved for EMVCo"));
      }

      for (int i = 80; i <= 99; i++) {
        SpecList.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "Unreserved Templates",
                Format: "S",
                Length: "99",
                Presence: "O",
                Comments:
                    "Unreserved templates can be allocated and used by other parties, such as (domestic) payment systems and value-added service providers, for their own products. They can then define the meaning, representation and format."));
      }
    }

    if (AdditionalSpecList.length <= 0) {
      AdditionalSpecList.insert(
          0,
          EMVSpec(
              Id: '01',
              Name: "Bill Number",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "The invoice number or bill number. This number could be provided by the merchant or could be an indication for the mobile application to prompt the consumer to input a Bill Number.\n\nFor example, the Bill Number may be present when the QR Code is used for bill payment."));

      AdditionalSpecList.insert(
          1,
          EMVSpec(
              Id: '02',
              Name: "Mobile Number",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "The mobile number could be provided by the merchant or could be an indication for the mobile application to prompt the consumer to input a Mobile Number.\n\nFor example, the Mobile Number to be used for multiple use cases, such as mobile top-up and bill payment."));

      AdditionalSpecList.insert(
          2,
          EMVSpec(
              Id: '03',
              Name: "Store Label",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "A distinctive value associated to a store. This value could be provided by the merchant or could be an indication for the mobile application to prompt the consumer to input a Store Label.\n\nFor example, the Store Label may be displayed to the consumer on the mobile application identifying a specific store."));

      AdditionalSpecList.insert(
          3,
          EMVSpec(
              Id: '04',
              Name: "Loyalty Number",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "Typically, a loyalty card number. This number could be provided by the merchant, if known, or could be an indication for the mobile application to prompt the consumer to input their Loyalty Number."));

      AdditionalSpecList.insert(
          4,
          EMVSpec(
              Id: '05',
              Name: "Reference Label",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "Any value as defined by the merchant or acquirer in order to identify the transaction. This value could be provided by the merchant or could be an indication for the mobile app to prompt the consumer to input a transaction Reference Label.\n\nFor example, the Reference Label may be used by the consumer mobile application for transaction logging or receipt display."));

      AdditionalSpecList.insert(
          5,
          EMVSpec(
              Id: '06',
              Name: "Customer Label",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "Any value identifying a specific consumer. This value could be provided by the merchant (if known), or could be an indication for the mobile application to prompt the consumer to input their Customer Label.\n\nFor example, the Customer Label may be a subscriber ID for subscription services, a student enrolment number, etc."));

      AdditionalSpecList.insert(
          6,
          EMVSpec(
              Id: '07',
              Name: "Terminal Label",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "A distinctive value associated to a terminal in the store. This value could be provided by the merchant or could be an indication for the mobile application to prompt the consumer to input a Terminal Label.\n\nFor example, the Terminal Label may be displayed to the consumer on the mobile application identifying a specific terminal."));

      AdditionalSpecList.insert(
          7,
          EMVSpec(
              Id: '08',
              Name: "Purpose of Transaction",
              Format: "ANS",
              Length: "25",
              Presence: "O",
              Comments:
                  "Any value defining the purpose of the transaction. This value could be provided by the merchant or could be an indication for the mobile application to prompt the consumer to input a value describing the purpose of the transaction.\n\nFor example, the Purpose of Transaction may have the value International Data Package for display on the mobile application."));

      AdditionalSpecList.insert(
          8,
          EMVSpec(
              Id: '09',
              Name: "Additional Consumer Data Request",
              Format: "ANS",
              Length: "03",
              Presence: "O",
              Comments:
                  "Contains indications that the mobile application is to provide the requested information in order to complete the transaction. The information requested should be provided by the mobile application in the authorization without unnecessarily prompting the consumer.\n\nFor example, the Additional Consumer Data Request may indicate that the consumer mobile number is required to complete the transaction, in which case the mobile application should be able to provide this number (that the mobile application has previously stored) without unnecessarily prompting the consumer.\n\nA=Address of consumer\nM=Mobile of consumer\nE=Email of Consumer"));

      for (int i = 9; i <= 48; i++) {
        AdditionalSpecList.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "Reserved for EMVCo",
                Format: "S",
                Length: "25",
                Presence: "O",
                Comments: ""));
      }

      for (int i = 49; i <= 99; i++) {
        AdditionalSpecList.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "Reserved for Bangladesh Payment Systems Operators",
                Format: "S",
                Length: "25",
                Presence: "O",
                Comments:
                    "Dynamically used by payment operators for use in Bangladesh"));
      }
    }

    if (LanguageTemplate.length <= 0) {
      LanguageTemplate.insert(
          0,
          EMVSpec(
              Id: '00',
              Name: "Language Preference",
              Format: "ANS",
              Length: "02",
              Presence: "M",
              Comments:
                  "Language Preference shall contain 2 alphabetical characters coded to a value defined by [ISO 639].\n\nThe value should represent the single language used to encode the Merchant Name—Alternate Language and the optional Merchant City—Alternate Language."));

      LanguageTemplate.insert(
          1,
          EMVSpec(
              Id: '01',
              Name: "Merchant Name—Alternate Language",
              Format: "S",
              Length: "25",
              Presence: "M",
              Comments:
                  "The Merchant Name—Alternate Language shall be present.\n\nThe Merchant Name—Alternate Language should indicate the “doing business as” name for the merchant in the merchant’s local language."));

      LanguageTemplate.insert(
          2,
          EMVSpec(
              Id: '02',
              Name: "Merchant City—Alternate Language",
              Format: "S",
              Length: "15",
              Presence: "O",
              Comments:
                  "f present, the Merchant City—Alternate Language should indicate the city in which the merchant transacts in the merchant’s local language."));

      for (int i = 3; i <= 99; i++) {
        LanguageTemplate.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "RFU for EMVCo",
                Format: "S",
                Length: "99",
                Presence: "O",
                Comments: "Data objects reserved for EMVCo"));
      }
    }

    if (MerchantAccountInfo.length <= 0) {
      MerchantAccountInfo.insert(
          0,
          EMVSpec(
              Id: '00',
              Name: "Globally Unique Identifier",
              Format: "ANS",
              Length: "32",
              Presence: "M",
              Comments:
                  "An identifier that sets the context of the data that follows.\nThe value is one of the following:\n• an Application Identifier (AID);\n• a [UUID] without the hyphen (-) separators;\n• a reverse domain name."));

      for (int i = 1; i <= 99; i++) {
        MerchantAccountInfo.insert(
            i,
            EMVSpec(
                Id: '01',
                Name: "Payment network specific",
                Format: "S",
                Length: "NA",
                Presence: "O",
                Comments:
                    "Association of data objects to IDs and type of data object is specific to the Globally Unique Identifier."));
      }
    }

    if (UnreservedTemplates.length <= 0) {
      UnreservedTemplates.insert(
          0,
          EMVSpec(
              Id: '00',
              Name: "Globally Unique Identifier",
              Format: "ANS",
              Length: "32",
              Presence: "M",
              Comments:
                  "An identifier that sets the context of the data that follows.\nThe value is one of the following:\n• an Application Identifier (AID);\n• a [UUID] without the hyphen (-) separators;\n• a reverse domain name."));

      for (int i = 1; i <= 99; i++) {
        UnreservedTemplates.insert(
            i,
            EMVSpec(
                Id: i.toString(),
                Name: "Context Specific Data",
                Format: "S",
                Length: "NA",
                Presence: "O",
                Comments:
                    "Association of data objects to IDs and type of data object is specific to the Globally Unique Identifier."));
      }
    }
  }

  EMVSpec GetSpecByIndex(int indx, String template) {
    if (template == '62') {
      return AdditionalSpecList[indx == 0 ? 0 : indx - 1];
    } else if (template == '64') {
      return LanguageTemplate[indx];
    } else if (template == '26-51') {
      return MerchantAccountInfo[indx];
    } else if (template == '80-99') {
      return UnreservedTemplates[indx];
    } else {
      return SpecList[indx];
    }
  }

  void AddTag(String Field, String Length, String Value) {
    // liEmvCo.add(Emvco(Field,Length,Value));
  }
}
