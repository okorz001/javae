# javae

compile and execute one-line Java programs

[![Build Status](https://travis-ci.com/okorz001/javae.svg?branch=master)](https://travis-ci.com/okorz001/javae)

## Requirements

* POSIX shell (`bash` specifically for test suite)
* JDK 7+ (`java` and `javac`)

## Installation

With Homebrew:

```sh
$ brew tap okorz001/javae
$ brew install javae --HEAD
```

From source with a local checkout:

```sh
$ make install
```

`make` will install to `/usr/local` by default. This can be changed with
`PREFIX`:

```sh
$ make PREFIX=/opt/javae install
```

## Usage

Options are briefly described in `javae -h`.

For more comprehensive documentation, consult the man page: `man javae`.

The man page for the latest successful build is hosted on GitHub Pages:
http://okorz001.github.io/javae

## Testing

`javae` uses [Bats][bats] for testing. Bats requires Bash.

```sh
$ make check
```

## Rationale

![But why?](http://giphygifs.s3.amazonaws.com/media/1M9fmo1WAFVK0/giphy.gif)

This all started as a troll response to the question:

> How can I get the current Unix timestamp in a shell script?

* `date +%s`
* `perl -e 'print time'`
* `d=$(mktemp -d);echo 'public class Main{public static void main(String[] args){System.out.println(System
.currentTimeMillis());}}'>$d/Main.java;javac $d/Main.java;java -cp $d Main;rm -rf $d`

![Java](https://making-the-web.com/sites/default/files/clipart/172320/java-png-transparent-images-172320-8303710.png)
![Troll face](https://i.imgur.com/KpCvMuf.png)

`javae` is the generalization and extension of this concept. However, please
recognize that is still ultimately a troll joke; `javae` should not be used in
any production system.

![Okay face)](https://i.imgur.com/WiBitAJ.jpg)

[bats]: https://github.com/bats-core/bats-core
