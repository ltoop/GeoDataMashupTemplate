## Geolocation Data Mashup Template

If you have attended the GovHack hackathons, a few things become very obvious:
1. People want to try new things and experiment with new technologies 
2. There are bucketloads of interesting geodata and ideas for making this available as mobile apps
3. Lots of teams are interested in making mobile apps, but very few actually make it to the finals with a working demo

This project is an attempt to help get more people over the hump and building useful apps in the course of a weekend:
* It's entirely Swift, which should be easier for people coming from Javascript / Python / Ruby.
* It has an abstract data model -- you should be able to hack around with the API data source file and get data from another source fairly easily.
* You should actually be able to add several data sources and then have them all display on the same map.

That said, this has only had about 6-8 hours worth of work, so there's a long, long way to go.

## Getting up and running

Dependencies have been kept to a minumum for productivity
This project will adopt Cocoapods as soon as they can support Swift frameworks and libraries. In the meanwhile, using git submodules or copying in dependencies directly is the way to do it :/

* Alamofire for networking
** this is a Git submodule, so you will need to run `git submodule init` to pull in the necessary files
* SwiftyJSON for JSON parsing
** This file has been incorporated directly. Check https://github.com/SwiftyJSON/SwiftyJSON for new versions. 

## Making your own modifications

1. Have a look at the Model and the SeismiData Source. 
2. Duplicate and hack on the Seismi class to fit another API with point geodata.
3. The model is extremely generic and lightweight, probably too much so. Add whatever extras you need and modify the sort functions as you need.
4. Feel free to fork and/or contribute other datasources to the repo. The more that come with the app, the easier future projects should become!

## Road Map

* Version 1 is the simplest thing that was worth releasing
** bare bones are up: the app launches, downloads some geodata (the Seismi Earthquake API, in this case) and displays on a map and a tableView.
** Selecting things on the tableview will zoom the map to the point

* Version 2 focus is to clean up a lot of UI functionality and some internals
** Add SegmentedControl to TableView so that user can change the sort order of the items
** User moving map to have a location in the centre should prompt the tableView to scroll to the item
** Data Model to leave the view controller
** Icons, image for load screen, review fonts and colours

* Version 3 big addition will be adding regions to the data model
** This opens up the potential for a lot more fun stuff

## Anything else?

GovHack is excellent fun and a great opportunity to meet interesting people. 
If you like playing with data (not even necessarily geodata!) you will love it :)

http://www.govhack.org