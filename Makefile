.PHONY: all clean distclean

BUILD_DEV := _build/device.ios/lib
BUILD_SIM := _build/simulator.ios/lib
BUILD_LIBS := $(BUILD_DEV)/libcaml.a $(BUILD_SIM)/libcaml.a
DUNE_DEPS := lib/lib.ml lib/cocoa.ml lib/libwrap.c lib/cocoa_stubs.c lib/dune

all: dist/libcaml.a dist/libcaml.h

$(BUILD_LIBS): $(DUNE_DEPS)
	dune build

dist/libcaml.a: $(BUILD_LIBS)
	lipo $^ -create -output $@

dist/libcaml.h: lib/libwrap.h
	cp $< $@

clean:
	dune clean

distclean: clean
	rm dist/*