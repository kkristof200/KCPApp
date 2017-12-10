# KCPApp
Cache | Show any ad of an app only by using its App Id

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
- Minimum required os version 8.0
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
