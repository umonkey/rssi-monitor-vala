# RSSI Indicator applet

This is a simple applet that displays 3G signal strength (RSSI) in the system tray area.

It reads the RSSI value using a remote HTTP endpoint, displays the raw value,
dBm and a proper icon with the bars.  The value is updated twice a second.

![Screenshot](https://user-images.githubusercontent.com/16797/70741378-30a35b00-1d2c-11ea-9d60-16190c5bc9c3.png)


## Installation

Ubuntu:

```bash
$ make depends-ubuntu build install
rssimon &
```


## TODO

- [x] Read URLs from [GSettings](https://wiki.gnome.org/Projects/Vala/GSettingsSample).
- [ ] Provide a deb package.
