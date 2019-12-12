# RSSI Indicator applet

This is a simple applet that displays 3G signal strength (RSSI) in the system tray area.

It reads the RSSI value using a remote HTTP endpoint, displays the raw value,
dBm and a proper icon with the bars.  The value is updated twice a second.


## Installation

Ubuntu:

```bash
$ make depends-ubuntu build install
rssimon &
```


## TODO

- [ ] Read URLs from the registry.
- [ ] Provide a deb package.
