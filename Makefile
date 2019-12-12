all: build

build: src/main.vala
	valac -o test --pkg gtk+-3.0 --pkg appindicator3-0.1 $<

depends-ubuntu:
	sudo apt install libappindicator3-dev gir1.2-appindicator3-0.1
