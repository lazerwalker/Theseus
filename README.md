Theseus [![Build Status](https://travis-ci.org/lazerwalker/Theseus.png)](https://travis-ci.org/lazerwalker/Theseus)
=======
Theseus is an open-source personal tracking tool that uses your iPhone's location and motion sensors to help you track and visualize where you spend your time. It's very similar to [Moves](http://moves-app.com) or [Google Latitude](https://en.wikipedia.org/wiki/Google_Latitude).

![Example images](https://raw.github.com/lazerwalker/Theseus/master/ReadmeImages/triptych.png)

One key difference between Theseus and other similar apps is its approach to privacy and data accessibility. By default, your data never leaves your phone; all processing happens on-device rather than an external server. If you want to access your data for personal usage, Theseus can export your data to Dropbox in JSON format for easy access.

The Status of Theseus
---------------------

**(You should read this)**

Theseus currently uses Apple's `CLVisit` CoreLocation APIs to determine what places you visit. However, as of iOS 8.0, CLVisit data isn't particularly accurate.

As such, rather than invest time polishing up Theseus and making it more full-featured, I'm basically going to leave it as-is for a while, in the hopes that future iOS updates make it more useful.

Writing custom location clustering code to replace `CLVisit` is doable, but would require more work than I'm currently interested in investing by myself. I'd be more than happy to jam on this with someone else if they wanted to lend a hand — get in touch if this is something that might interest you!

Installation
------------
Although Theseus will eventually be available on the App Store, you must currently compile it from source. Assuming you want to run Theseus on your physical iPhone, you'll also need to be a member of Apple's [iOS Developer Program](https://developer.apple.com/devcenter/ios/index.action). It requires iOS 8.

1. Clone this git repo: `git clone git@github.com:lazerwalker/Theseus.git`

2. Copy `Configuration.plist.example` to `Configuration.plist`.

3. Create a new Foursquare app (https://foursquare.com/developers/register). This will be necessary to fetch venue information from Foursquare.

4. Create a new Dropbox app (https://www.dropbox.com/developers/apps). It should be a Dropbox API app, with access to Files and Datastores, that can be limited to its own folder. This will be necessary to export your data to Dropbox.

5. Open up `Theseus.xcworkspace` in Xcode. Open `Configuration.plist`, and enter the credentials for the Dropbox and Foursquare apps you created in the previous step.

6. Build and run the app. It should just work!


Usage
-----
After you grant Theseus permission to access motion and location data, it will start collecting data about where you spend your time. Currently, it will group all of your actions into either a stop, where you are staying in a discrete location for a period of time, or a movement event, when you're travelling. Stops can either be correlated to nearby Foursquare venues or given their own names; as you categorize locations, Theseus will begin to suggest those names when you are in that place again.

Theseus visualizes your data in a timeline per day, letting you change days by swiping. You can also tap any item to see that day's movement visualized on a map.

If you would like to export your data, the Settings menu offers a one-button JSON export to Dropbox. More export options will be coming soon.

For now, you may manually need to tap the 'Process' button in the top-left to trigger processing of your location data into a higher-level collection of stop and movement events.


Issues
------
Theseus is currently VERY EARLY alpha software. It will crash a lot. You may lose your data, so export regularly if you care.

If you run into problems, please file bugs using this repo's [GitHub Issues](https://github.com/lazerwalker/Theseus/issues). If you run into problems with how your movement is being categorized (incorrect timestamps, coordinates, etc) and feel comfortable sharing your data, you can get a raw export of your movement and motion data by choosing the "Export Raw Data" option from the app's settings page; this will be very helpful.


Running Tests from the Command Line
-----------------------------------
You can run Theseus's test suite from the command line by running the `rake test` command from inside the root project directory.

As a warning: the test suite *will* overwrite the app's database in the simulator with test data. It's unlikely you will have meaningful data stored in your simulator instance of the app, but keep this in mind.

Right now, test coverage is a bit shaky; this is a relatively high near-term priority.


Contributing
------------
Contributions of all shapes and forms are welcome! If you're looking for something to do, check out the [GitHub Issues](https://github.com/lazerwalker/Theseus/issues) or feel free to get in touch directly.

Before your first pull request is accepted, you will need to submit a Contributor License Agreement by filling out this form:

**[Theseus CLA](https://docs.google.com/forms/d/1aQZYW0zHQYSrKaFlCgZUnRvwz0gy-ZIgokbMKLOFL5M/viewform)**

Without a signed CLA, I won't be able to include your code in any builds I submit to Apple for distribution on the App Store.

### Info.plist
Using the Dropbox API requires the app to register a URI scheme of the form `db-<APP KEY>`. This automated as part of the build process; whatever app key you have in your `Configuration.plist` file will be used.

Because the info plist is versioned (and adding it to `gitignore` isn't a viable option), this means it will show up as part of your git changeset. For now, you'll have to manually discard it from your working index when you commit.

Please try to remember to do this, but don't freak out if you accidentally do commit it; a Dropbox app key isn't considered sensitive information, so it isn't the end of the world.


Contact
-------
Mike Lazer-Walker

- https://github.com/lazerwalker
- [@lazerwalker](http://twitter.com/lazerwalker)
- http://lazerwalker.com


License
-------
Theseus is available under the GPL v2 license. See the LICENSE file for more info.
