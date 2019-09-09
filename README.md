# javae

`perl -e` for Java

## Requirements

* POSIX shell (`bash` specifically for test suite)
* JDK 7+ (`java` and `javac`)

## Usage

`javae` is a utility for writing "one-liners" in Java. The provided function
body is wrapped in a class and called by the class's `main` method.

```sh
$ javae 'System.out.println(System.currentTimeMillis());'
1568003592358
```

Convenience methods `print`, `println` and `printf` are defined that forward
to the same methods of `System.out`. The previous example can be shortened to:

```sh
$ javae 'println(System.currentTimeMillis());'
1568003592358
```

### Processing Lines

`-n` executes the function body once for every line of text in the input. The
current line is available in the static (and mutable) String variable `LINE`.

```sh
$ printf '1\n2\n' | javae -n 'println(LINE + "a");'
1a
2a
```

`-p` is similar to `-n`, except that it implicitly adds `println(LINE);`
after the function body. The previous example can be rewritten as:

```sh
$ printf '1\n2\n' | javae -p 'LINE += "a";'
1a
2a
```

### Debugging

`-d` dumps the generated Java source file and quits without executing it.

## Testing

`javae` uses [Bats][bats] for testing. Bats requires Bash.

```sh
$ bats javae.bats
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
