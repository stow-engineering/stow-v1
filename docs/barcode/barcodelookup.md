# Barcode Lookup API Documentation

## Background 
The [Barcode Lookup API](https://www.barcodelookup.com/api) searches for UPC, EAN, and ISBN records in their database - these are described below:

- __Universal Product Code (UPC)__: used for tracking trade items in stores, specifically at the point of sale; used in US, Canada, UK, Australia, New Zealand, etc.
- __International Article Number (EAN)__: European and international vendors - identifies specific retail, package configuration, manufacturer
- __International Standard Book Number (ISBN)__: Compatible with EAN - used for identifying books (not relevant)

Barcode claims to work directly with 5000 retailers to obtain their information - this should be verified to see how up to date it is. 

## API Description

### Base Endpoint: 

``https://api.barcodelookup.com/v3/products?``

- Add parameters to URL, separated by ampersands
- Must add key as param (set as ENV variable)
- Always include ``formatted=y`` as parameter

An example API call is the following:

``https://api.barcodelookup.com/v3/products?barcode=3614272049529&formatted=y&key=your_api_key``

### Relevant Search Parameters
- ``barcode (int)``
- ``title (string)``
- ``brand (string)``
- ``search (string)``
- ``geo (string)``

### Relevant Return Values
- ``nutrition_facts(string)``
- ``ingredients (string)``

### Checking Rate Limits
As we'll be restricted on the number of API calls made, one must check the number of calls remaining:

Call Example:

``https://api.barcodelookup.com/v3/rate-limits?formatted=y&key=your_api_key``

## Scanning the Barcode

There's a package that can be used to actually scan the barcode: [flutter_barcode_scanner](https://pub.dev/packages/flutter_barcode_scanner). 