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
  ./javae -d 'print("hello");' | head -n 4 >"$actual"
  cat >"$expected" <<EOF
public class SCRIPT {
  private static String[] ARGV;
  private static String LINE;
  public static void main(String[] args) throws Exception {
EOF
  assert_files
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
