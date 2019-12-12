all: build

build: rssimon

depends-ubuntu:
	sudo apt install libappindicator3-dev gir1.2-appindicator3-0.1 libsoup2.4-dev

install: build
	umask 022
	sudo cp -f rssimon /usr/local/bin/
	sudo cp src/schema.xml /usr/share/glib-2.0/schemas/net.umonkey.rssimon.gschema.xml
	sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

rssimon: src/main.vala
	valac -o $@ --pkg gtk+-3.0 --pkg appindicator3-0.1 --pkg posix --pkg libsoup-2.4 $<

run: build
	./rssimon
