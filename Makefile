BUILD_DIR := build
BIN       := $(BUILD_DIR)/odinSnake
SRC       := src
ANGLE_DIR := angle

.PHONY: all build run clean

all: build

build:
	@mkdir -p $(BUILD_DIR)
	odin build $(SRC) \
		-out:$(BIN) \
		-collection:project=. \
		-extra-linker-flags:"-rpath @executable_path/"
	cp $(ANGLE_DIR)/libEGL.dylib    $(BUILD_DIR)/
	cp $(ANGLE_DIR)/libGLESv2.dylib $(BUILD_DIR)/

run: build
	./$(BIN)

clean:
	rm -rf $(BUILD_DIR)
