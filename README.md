# FindMyStation

An iOS application to locate and display electric vehicles charging stations 1km away from you in Switzerland.


## Requirements

### [SHOULD] As a user I want to see a map centered around my current position

Acceptance criteria:
* opening the app, a map is presented
* the initial map position is the current user location
* the map does not need to be scrollable

### [SHOULD] As a user I want to see all charging stations in the radius of 1km of my position on the map

Acceptance criteria:
* charging stations are visible on the map at their correct location
* validate against map.geo.admin.ch (see below)

### [MUST] As a user I want to see all charging stations in the radius of 1km of my position on a list

Acceptance criteria:
* a second tab is available in the app, showing a list of charging stations
* the list shall be sorted by "Power", descending (i.e. stations with highest charging power at the top)
* list entries shall display "id", "Power" and availability at a minimum


### [SHOULD] As a user I want to see a different icon for the charging station based on its availability

Acceptance criteria:
* charging station icons are different (or in a different color) based on their availability status
* validate against map.geo.admin.ch (see below)

### [MUST] As a user I want to see availability in real time, without the need to reload data manually

Acceptance criteria:
* charging station availability is updated automatically
* a 'last update' field shows in the UI when the last data update took place
* validate against map.geo.admin.ch (see below)


### [MUST] As a user I want to be able to see the last loaded list of charging stations when I am offline

Acceptance criteria:
* open the app with internet connectivity available synchronizes the available charging stations around me
* disabling internet connectivity, terminating the app and re-opening it results in the list to be available
* the map does not need to be cached/stored. In offline mode only the list is available


* https://map.geo.admin.ch/?lang=en&topic=energie&bgLayer=ch.swisstopo.pixelkarte-grau&zoom=0&layers=ch.bfe.ladestellen-elektromobilitaet&catalogNodes=2419,2420,2427,2480,2429,2431,2434,2436,2767,2441,3206 can be used to validate the app. It shows all charging stations in switzerland with their current state


## Future work and improvements
- [Improvement] Error handling
- [Improvement] Handling network connection issues
- [Feature] Adding guiding route to the charging station
- [Feature] Ability to order stations of the list by distance from current location

