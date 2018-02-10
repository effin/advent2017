import strutils, tables, sequtils

var rules = initTable[string, string]()

proc reverseString(s: string): string =
    result = s
    for i in 0 .. s.high div 2:
        swap(result[i], result[s.high - i])

proc reverse[T](xs: openarray[T]): seq[T] =
  result = newSeq[T](xs.len)
  for i, x in xs:
    result[^i-1] = x #

proc flip(square: string): string =
    result = join(reverse(split(square, '/')), "/")

proc flap(square: string): string =
    var rows = split(square, '/')
    result = join(map(rows, reverseString), "/")

proc rotate(s: string): string =
    if high(s) == 4:
        result = s[3] & s[0] & "/" & s[4] & s[1]
    else:
        result = s[8] & s[4] & s[0] & "/" & s[9] & s[5] & s[1] & "/" & s[10] & s[6] & s[2]

proc rotate2(s: string): string = rotate(rotate(s))
proc rotate3(s: string): string = rotate(rotate2(s))

proc makeSquares(image: string, w: int): seq[seq[string]] =
    var rows = split(image, '/')
    result = @[]
    var i = -1
    for r in 0..high(rows):
        if r mod w == 0:
            i = i + 1
            add(result, @[])
        var j = 0
        while rows[r].len > 0:
            if result[i].len < (j + 1):
                add(result[i], "")
            if r mod w > 0:
                result[i][j] = result[i][j] & "/"
            result[i][j] = result[i][j] & rows[r][0..w - 1]
            delete(rows[r], 0, w - 1)
            j = j + 1

proc makeSquares(image: string): seq[seq[string]] =
    if find(image, '/') mod 2 == 0:
        result = makeSquares(image, 2)
    else:
        result = makeSquares(image, 3)

proc toString(squares: seq[seq[string]]): string =
    var rows: seq[string] = @[]
    for i in low(squares)..high(squares):
        for j in 0..high(squares[0]):
            let squarerows = split(squares[i][j], '/')
            for s in 0..high(squarerows):
                let rownum = i*(high(squarerows) + 1) + s
                if rownum > high(rows):
                    rows.add("")
                rows[rownum] = rows[rownum] & squarerows[s]
    result = join(rows, "/")

proc convert(square: string): string =
    result = rules[square]

proc addAllRules() =
    var r = rules
    for k in r.keys:
        add(rules, flip(k), rules[k])
        add(rules, flap(k), rules[k])
        add(rules, rotate(k), rules[k])
        add(rules, rotate2(k), rules[k])
        add(rules, rotate3(k), rules[k])
        add(rules, flip(rotate(k)), rules[k])
        add(rules, flap(rotate(k)), rules[k])

proc doIteration(image: string): string =
    var squares = makeSquares(image)
    squares = map(squares, proc(x: seq[string]): seq[string] = map(x, convert))
    result = toString(squares)

var
  f: File
  image = ".#./..#/###"
if open(f, "input21.txt"):
  try:
    for line in f.lines:
        let r = split(line, " => ")
        add(rules, r[0], r[1])
  except IOError:
    echo "IO error!"
  except:
    echo "Unknown exception!"
    raise
  finally:
    close(f)

addAllRules()

let numIters = 18
for i in 1..numIters:
    image = doIteration(image)
    echo i, " = ", count(image, '#')