
CWD=$(shell pwd)
GOPATH := $(CWD)

prep:
	if test -d pkg; then rm -rf pkg; fi

self:   prep
	if test -d src; then rm -rf src; fi
	mkdir -p src/github.com/aaronland/go-unicode-table
	cp -r http src/github.com/aaronland/go-unicode-table/
	cp -r vendor/* src/

rmdeps:
	if test -d src; then rm -rf src; fi 

deps:
	@GOPATH=$(GOPATH) go get -u "github.com/jteeuwen/go-bindata"
	@GOPATH=$(GOPATH) go get -u "github.com/elazarl/go-bindata-assetfs/"
	rm -rf src/github.com/jteeuwen/go-bindata/testdata

vendor-deps: rmdeps deps
	if test ! -d vendor; then mkdir vendor; fi
	cp -r src/* vendor/
	find vendor -name '.git' -print -type d -exec rm -rf {} +
	rm -rf src

static:
	if test ! -d tmp; then mkdir tmp; fi
	git clone https://github.com/aaronland/unicode-table.git tmp/unicode-table
	if test -d www; then rm -rf www; fi
	mv tmp/unicode-table/www www
	rm -rf tmp

bundle: self
	@GOPATH=$(GOPATH) go build -o bin/go-bindata ./vendor/github.com/jteeuwen/go-bindata/go-bindata/
	@GOPATH=$(GOPATH) go build -o bin/go-bindata-assetfs vendor/github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs/main.go
	rm -f www/*~ www/css/*~ www/javascript/*~
	@PATH=$(PATH):$(CWD)/bin bin/go-bindata-assetfs -pkg http www www/javascript www/css
	if test -f http/static_fs.go; then rm http/static_fs.go; fi
	if test ! -d http; then mkdir http; fi
	mv bindata_assetfs.go http/static_fs.go

build:
	@make bundle
	@make bin

debug:
	@make build
	bin/unicode-table

fmt:
	go fmt cmd/*.go
	go fmt http/*.go
	go fmt *.go

bin: 	rmdeps self
	rm -rf bin/*
	@GOPATH=$(GOPATH) go build -o bin/unicode-table cmd/unicode-table.go

docker-build:
	@make build
	docker build -t unicode-table .

docker-debug: docker-build
	docker run -it -p 8080:8080 unicode-table
