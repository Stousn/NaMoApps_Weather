# NaMoApps: Adaptive Weather App for iOS in Swift 4
Project for Native Mobile Apps @ FH JOANNEUM - IT&amp;Mobile Security Master


## Problem
* Short look on a display
* visual impairment
	* "without glasses"
* Lots of small (and unimportant) information


## Idea
* If the device is far away
	* Less details
	* Only the most important info
* If the device is close to the face
	* More details
	* Smaller texts ans graphics

=> Example implementation: Weather-App


## Results
<table>
  <tr>
    <td rowspan="3">Must:</td>
    <td>Weather-App based on GPS location & search</td>
  </tr>
  <tr>
    <td>Weather API integrated</td>
  </tr>
  <tr>
    <td>Adaptive UI</td>
  </tr>
    <tr>
    <td rowspan="3">Can:</td>
    <td>Watch App (zoomable via Digital Crown)</td>
  </tr>
  <tr>
    <td>Conform to A11Y-rulsets</td>
  </tr>
  <tr>
    <td>Notifications</td>
  </tr>
</table>


## Steps
1. Basic working weather app
	* UI design and implementation
	* API integration
	* Gather GPS-position
2. Adaptive UI size
	* Make all screens adaptable in size
	* Read and calculate distance between face and screen
