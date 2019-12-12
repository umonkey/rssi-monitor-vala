all: build

build: rssimon

rssimon: src/main.vala
	valac -o $@ --pkg gtk+-3.0 --pkg appindicator3-0.1 --pkg posix --pkg libsoup-2.4 $<

depends-ubuntu:
	sudo apt install libappindicator3-dev gir1.2-appindicator3-0.1 libsoup2.4-dev
