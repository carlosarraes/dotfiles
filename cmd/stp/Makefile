BINARY := stp
BUILD_DIR := bin

.PHONY: build clean

build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o $(BUILD_DIR)/$(BINARY)-linux-amd64 .

clean:
	rm -rf $(BUILD_DIR)
