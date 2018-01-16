# go-unicode-table

Experimental Go package to bundle the [unicode-table](https://aaronland.github.io/unicode-table/) website and an HTTP server in one handy binary file.

## Install

You will need to have both `Go` (specifically a version of Go more recent than 1.7 so let's just assume you need [Go 1.9](https://golang.org/dl/) or higher) and the `make` programs installed on your computer. Assuming you do just type:

```
make bin
```

All of this package's dependencies are bundled with the code in the `vendor` directory.

## Usage

This package builds a single binary application called `unicode-table` that launches a web server hosting the [unicode-table](https://aaronland.github.io/unicode-table/) application. You can start the server like this:

```
./bin/unicode-table 
2018/01/16 13:22:12 listening on localhost:8080
```

And then visit `http://localhost:8080/`  in your web browser.

### Updating things

This package bundles the `www` directory from the [unicode-table](https://github.com/aaronland/unicode-table) repository. To fetch a fresh copy run the `static` target in the Makefile, like this:

```
make static
if test ! -d tmp; then mkdir tmp; fi
git clone https://github.com/aaronland/unicode-table.git tmp/unicode-table
Cloning into 'tmp/unicode-table'...
remote: Counting objects: 343, done.        
remote: Total 343 (delta 0), reused 0 (delta 0), pack-reused 343        
Receiving objects: 100% (343/343), 3.77 MiB | 86.00 KiB/s, done.
Resolving deltas: 100% (163/163), done.
if test -d www; then rm -rf www; fi
mv tmp/unicode-table/www www
rm -rf tmp
```

If you need or want to make changes to the files in the `www` directory you will need to "re-bundle" them by running the `bundle` target in the Makefile, like this:

```
make bundle
if test -d pkg; then rm -rf pkg; fi
if test -d src; then rm -rf src; fi
mkdir -p src/github.com/aaronland/go-unicode-table
cp -r http src/github.com/aaronland/go-unicode-table/
cp -r vendor/* src/
rm -f www/*~ www/css/*~ www/javascript/*~
if test -f http/static_fs.go; then rm http/static_fs.go; fi
if test ! -d http; then mkdir http; fi
mv bindata_assetfs.go http/static_fs.go
```

## Docker

[Yes](Dockerfile), for example:

```
docker build -t unicode-table .
docker run -it -p 8080:8080 unicode-table
```

## See also

* https://github.com/aaronland/unicode-table
