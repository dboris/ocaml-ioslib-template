.PHONY: all clean

BUILD_DEV=_build/4.14.0+ios-device.ios/lib
BUILD_SIM=_build/4.14.0+ios-simulator.ios/lib

all: dist/libcaml.a dist/libcaml.h

$(BUILD_DEV)/libcaml.a $(BUILD_SIM)/libcaml.a: lib/lib.ml lib/libwrap.c lib/dune
	dune build

dist/libcaml.a: $(BUILD_DEV)/libcaml.a $(BUILD_SIM)/libcaml.a
	lipo $^ -create -output $@

dist/libcaml.h: lib/libwrap.h
	cp $< $@

clean:
	dune clean