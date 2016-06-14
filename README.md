# TripPlannerDemo

TripPlannerDemo  App, is a simple app that allows the users to select source, destination & date of their trips. It uses GoEuro web service to provide suggestions
It demostrate creating custom UI's, creating the UI from the story board as well from the code as well integrating swift with objective-c!

## Data Classes

- Place: Hold the information regarding the suggested locations (location, name, city, country ..etc)

## UI Classes

- DatePickerPopoverViewController: DatePicker view controller for selecting dates written in Swift
- AutocompleteViewController: View controller used to serach nearby places
- AutocompleteAnimator: Used to provide custom animation for AutocompleteViewController
- MainViewController: Our main (landing) view controller

## Network Classes
- WebBaseAPI: The base class that is being used by the API to GET data
- WebGetSuggestionAPI: Class for fetching auto complete suggestions from the server

## Installation

The Code is known to work best with iOS 9.0 on iPhone devices, it plays niceley on iPad and haven't been tested on earlier iOS versions

## TODO

- Unit Test & UI Test
- The animation for date picker need to be custom inorder to have the look and feel of the rest of the UI elements, however I used popover for simplicity

## Others

Different techqnices have been used to show different ways of doing things. For example:
- I created the UI from the code in AutocompleteViewController and from the .xib in MainViewController
- I used Swift to code DatePickerPopoverViewController to show how to integrate Swift with Objective-C
