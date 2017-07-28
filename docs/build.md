# Build

[![CircleCI](https://circleci.com/gh/troyfontaine/alpinelinux.svg?style=svg)](https://circleci.com/gh/troyfontaine/alpinelinux)

A convenience `build` script is included that builds the image and can run basic tests against the resulting image tags. The script is used in the continuous integration process (check out the CircleCI badge link above). But you can run this script locally to build your own images. Be sure to check out the environment variables that can be tweaked at the top of the `build` script file.

## Image

### Builder

The image is built using a multi-stage Dockerfile.

### Options

The build script takes a glob of `options` files as an argument. Each of these files lives in a folder that describes the version of Alpine Linux to build. Each line of the `options` file are the options that will be applied to the resulting image. By default, we use the included glob of `arch/<arch>/**/options`.

### Example

To build all the images used for testing, simply run:

```console
$ ./build
```

To build the minimal ARMHF image, run:

```console
$ ./build release
```

Pass version files to the `build` script to build specific versions:

```console
$ ./build arch/<arch>/stock-3.5/options
```

With `parallel` available you can speed up building a bit (this hasn't been tested on this fork):

```console
$ parallel -m ./build ::: arch/<arch>/**/options
```

## Testing

The test for images is very simple at the moment. It just attempts to install the `openssl` package and verify we exit cleanly.

Use the `test` sub-command of the `build` utility to run tests on currently built images (`build test`).

### Example

Run tests for a single image:

```console
$ ./build test versions/gliderlabs-3.2/options
 ✓ version is correct
 ✓ package installs cleanly
 ✓ timezone
 ✓ repository list is correct
 ✓ cache is empty
 ✓ root password is disabled

7 tests, 0 failures
```

Run all tests:

```console
$ ./build test
 ✓ version is correct
 ✓ package installs cleanly
 ✓ timezone
...
 ✓ repository list is correct
 ✓ cache is empty
 ✓ root password is disabled

84 tests, 0 failures
```

Run tests in parallel with the `parallel` utility:

```console
$ parallel ./build test ::: arch/<arch>/**/options
1..7
ok 1 version is correct
ok 2 package installs cleanly
ok 3 timezone
...
...
```
