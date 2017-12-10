![Platform](https://img.shields.io/badge/platform-iOS%208.0%2B-blue.svg) ![Language](https://img.shields.io/badge/language-ObjC-blue.svg)

# KCPApp
Cache | Show any ad of an app only by using its App Id

# Idea
Needed a framework for cross promoting my apps, and found [JanC's Tapromotee](https://github.com/JanC/TAPromotee), but it didn't fit my needs, so I rewrote it, rebuilt the UI, added more functionalities to it, and covered more "edge cases".

# Preview
![Alt Text](https://media.giphy.com/media/3o6fJ0xFdOvw1PcvKM/giphy.gif)
![Alt Text](https://media.giphy.com/media/3o6fIXdAPdTgwRhfmE/giphy.gif)

# Features
- Download, parse and cache all relevant data about an app only by its App Id.
- Can do this to an array of ids, that you're planning to show in the future.
- Create thematic "Ad" ViewController, based on the colors of the apps icon and screenshots.
- Show/Hide average rating and rating count based on the average rating.
- Supports iPad/iPhone (both portrait and landscape)
- Shows both landscape and portrait oriented screenshots
- Shows apps price in local currency
- Verifies if the requested app is available on the current device (minimum ios version, device type, country)

# Requirements
- Minimum required iOS version 8.0
- Add the following code to your info.plist file
```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>mzstatic.com</key>
		<dict>
			<!--Include to allow subdomains-->
			<key>NSIncludesSubdomains</key>
			<true/>
			<!--Include to allow HTTP requests-->
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<!--Include to specify minimum TLS version-->
			<key>NSTemporaryExceptionMinimumTLSVersion</key>
			<string>TLSv1.1</string>
		</dict>
	</dict>
</dict>
```

# Acknowledgements
I've used the following libraries for building KCPApp
- [Reachability](https://developer.apple.com/library/content/samplecode/Reachability/Introduction/Intro.html)
- [EGOCache](https://github.com/enormego/EGOCache)
- [Facade](https://github.com/mamaral/Facade)
- [Chameleon](https://github.com/ViccAlexander/Chameleon)(A small part of it)
- [StarRatingView](https://github.com/liaojinxing/StarRatingView)(my modified version)
