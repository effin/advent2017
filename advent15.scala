object advent15 {

  def nextA(a: Long): Long = (a * 16807) % 2147483647

  def nextB(b: Long): Long = (b * 48271) % 2147483647

  def same(a: Long, b: Long): Int = if ((a & 0xffff) == (b & 0xffff)) 1 else 0

  def next2(f: Long => Long, d: Int) = (x: Long) => {
    var y = f(x)
    while (y % d != 0) {
      y = f(y)
    }
    y
  }

  def count(fA: Long => Long, fB: Long => Long, m: Int): Int = {
    var x = 0
    var c = 0
    var a = 591L
    var b = 393L
    for (x <- 1 to m) {
      a = fA(a)
      b = fB(b)
      c += same(a, b)
    }
    c
  }

  def main(args: Array[String]) {
    println(count(nextA, nextB, 40000000))
    println(count(next2(nextA, 4), next2(nextB, 8), 5000000))
  }
}
