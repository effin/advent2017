import java.io.File
import java.util.stream.Collectors

val treeMap = hashMapOf<String, List<String>>()
val weights = hashMapOf<String, Int>()

fun main(args: Array<String>) {
    readInput()
    println("root: ${getRoot()}")
    println("weight: ${getCorrectedWeight()}")
}

fun getRoot(): String? {
    for (entry in treeMap) {
        if (entry.value?.size > 0) {
            if (!treeMap.values.stream().filter({ t -> t.contains(entry.key) }).findAny().isPresent()) {
                return entry.key;
            }
        }
    }
    return null
}

fun getCorrectedWeight(): Int? {
    val t = getUnbalancedNodesRoot()
    val w0 = getWeight(treeMap.get(t)?.get(0)) // assume 0 is not the fat one
    for (c in treeMap.get(t) ?: mutableListOf())
        if (getWeight(c) != w0) {
            return weights.get(c)!! - getWeight(c) + w0
        }
    return null
}

fun getUnbalancedNodesRoot(): String? {
    val unbalanced = getUnbalancedNodes()
    for (node in unbalanced) {
        if (treeMap.get(node)?.intersect(unbalanced)!!.isEmpty())
            return node
    }
    return null
}

fun getUnbalancedNodes(): List<String> {
    return treeMap.keys.stream().filter({ t -> unbalanced(t) }).collect(Collectors.toList())
}

fun unbalanced(t: String?): Boolean {
    if (treeMap.get(t)?.size == 0)
        return false
    val w0 = getWeight(treeMap.get(t)?.get(0))
    for (c in treeMap.get(t) ?: mutableListOf())
        if (getWeight(c) != w0)
            return true
    return false
}

fun getWeight(name: String?): Int {
    var sum = weights.get(name) ?: 0;
    for (c in treeMap.get(name) ?: mutableListOf<String>()) {
        sum += getWeight(c)
    }
    return sum
}

fun readInput() {
    File("input7.txt").useLines { lines ->
        lines.forEach {
            val l = it.split(' ')
            val s = l.size - 1
            val aList = mutableListOf<String>()
            for (a in 3..s) {
                var n = l[a]
                if (n.endsWith(','))
                    n = n.substring(0, n.length - 1)
                aList.add(n)
            }
            treeMap.put(l[0], aList)
            val ws = l[1].substring(1, l[1].length - 1)
            weights.put(l[0], ws.toInt())
        }
    }
}