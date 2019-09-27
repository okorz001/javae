#!/usr/bin/env bats

# temporary directory for output
dir=
trap '[[ -n "$dir" ]] && rm -rf "$dir"' EXIT
dir=$(mktemp -d)

# this prevents parallel test execution
expected="$dir/expected"
actual="$dir/actual"

assert_files() {
  diff -au --label expected "$expected" --label actual "$actual"
}

@test "print" {
  ./javae 'print(1); print(2);' >"$actual"
  printf '12' >"$expected"
  assert_files
}

@test "println" {
  ./javae 'println(1); println(2);' >"$actual"
  printf '1\n2\n' >"$expected"
  assert_files
}

@test "printf" {
  ./javae 'printf("%.02f", 1d);' >"$actual"
  printf '1.00' >"$expected"
  assert_files
}

@test "-d" {
  # just assert the class and main, since we may add more helper methods
  ./javae -d 'print("hello");' | head -n 5 >"$actual"
  # inspect file contents without asserting entire content line-by-line
  # basic class definition
  grep -F 'public class SCRIPT' "$actual"
  # basic main definition
  grep -F 'public static void main(String[]' "$actual"
  # our program
  grep -F 'print("hello");' "$actual"
}

@test "-p empty" {
  ./javae -p '' >"$actual" <<EOF
1
2
3
EOF
  cat >"$expected" <<EOF
1
2
3
EOF
  assert_files
}

@test "-p simple" {
  ./javae -p 'LINE = LINE + "_";' >"$actual" <<EOF
1
2
3
EOF
  cat >"$expected" <<EOF
1_
2_
3_
EOF
  assert_files
}

@test "-p file" {
  cat >"$dir/1" <<EOF
1
2
3
EOF
  ./javae -p '' "$dir/1" </dev/null >"$actual"
  cat >"$expected" <<EOF
1
2
3
EOF
  assert_files
}

@test "-p files" {
  cat >"$dir/1" <<EOF
1
2
3
EOF
  cat >"$dir/2" <<EOF
4
5
6
EOF
  ./javae -p '' "$dir/1" "$dir/2" </dev/null >"$actual"
  cat >"$expected" <<EOF
1
2
3
4
5
6
EOF
  assert_files
}

@test "-p -" {
  ./javae -p '' - >"$actual" <<EOF
1
2
3
EOF
  cat >"$expected" <<EOF
1
2
3
EOF
  assert_files
}

@test "-p - and files" {
  cat >"$dir/1" <<EOF
1
2
3
EOF
  cat >"$dir/2" <<EOF
7
8
9
EOF
  ./javae -p '' "$dir/1" - "$dir/2" >"$actual" <<EOF
4
5
6
EOF
  cat >"$expected" <<EOF
1
2
3
4
5
6
7
8
9
EOF
  assert_files
}

@test "-n empty" {
  ./javae -n '' >"$actual" <<EOF
1
2
3
EOF
  cat >"$expected" </dev/null
  assert_files
}

@test "-n simple" {
  ./javae -n 'if (!LINE.equals("2")) println(LINE);' >"$actual" <<EOF
1
2
3
EOF
  cat >"$expected" <<EOF
1
3
EOF
  assert_files
}

@test "-a" {
  ./javae -na 'println(FIELDS[1]);' >"$actual" <<EOF
foo bar
spam eggs
EOF
  cat >"$expected" <<EOF
bar
eggs
EOF
  assert_files
}

@test "-F" {
  ./javae -naF: 'println(FIELDS[1]);' >"$actual" <<EOF
foo:bar
spam:eggs
EOF
  cat >"$expected" <<EOF
bar
eggs
EOF
  assert_files
}

@test "-F regex" {
  ./javae -naF '\\d+' 'println(FIELDS[1]);' >"$actual" <<EOF
foo123bar
spam0eggs
EOF
  cat >"$expected" <<EOF
bar
eggs
EOF
  assert_files
}

@test "-m" {
  ./javae -m'java.time.*' 'println(Instant.ofEpochMilli(0));' >"$actual"
  echo '1970-01-01T00:00:00Z' >"$expected"
  assert_files
}

@test "-M" {
  ./javae -M'java.time.Instant.*' 'println(ofEpochMilli(0));' >"$actual"
  echo '1970-01-01T00:00:00Z' >"$expected"
  assert_files
}
