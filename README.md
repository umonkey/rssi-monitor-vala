# RSSI Indicator applet

This is a simple applet that displays 3G signal strength (RSSI) in the system tray area.

It reads the RSSI value using a remote HTTP endpoint, displays the raw value,
dBm and a proper icon with the bars.  The value is updated twice a second.

![Screenshot](https://user-images.githubusercontent.com/16797/70741248-ea4dfc00-1d2b-11ea-8b0b-e96a8acd8f00.png)


## Installation

Ubuntu:

```bash
$ make depends-ubuntu build install
rssimon &
```


## TODO

- [x] Read URLs from [GSettings](https://wiki.gnome.org/Projects/Vala/GSettingsSample).
- [ ] Provide a deb package.
