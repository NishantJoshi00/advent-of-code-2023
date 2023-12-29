

enum class Signal {
    High,
    Low,
}

enum class State {
    On,
    Off,
}

class Module(val data: String) {
    val intermediate = data.split(" -> ")
    val type = intermediate[0][0]
    val outputs = intermediate[1].split(", ")
    var name = intermediate[0].slice(1..(intermediate[0].length - 1))
    var pmem = State.Off
    var amem = hashMapOf<String, Signal>()

    fun display() {
        if (type == '%') {
            println("$type : $outputs : $pmem")
        } else {
            println("$type : $outputs : $amem")
        }
    }

    fun operate(
        workQ: ArrayList<Triple<String, String, Signal>>,
        origin: String,
        signal: Signal,
    ) {
        if (type == '%') {
            if (signal == Signal.High) {
                return
            }
            pmem = if (pmem == State.Off) State.On else State.Off
            val output = if (pmem == State.On) Signal.High else Signal.Low
            for (target in outputs) {
                workQ.add(Triple(name, target, output))
            }
        } else {
            amem[origin] = signal
            var state = true
            amem.forEach { (key, value) -> state = state && (value == Signal.High) }
            val output = if (state) Signal.Low else Signal.High
            for (target in outputs) {
                workQ.add(Triple(name, target, output))
            }
        }
    }
}

fun main(args: Array<String>) {
    var broadcastArray = ArrayList<String>()
    var moduleMapping = hashMapOf<String, Module>()

    var current = readLine()
    while (current != null) {
        var data = current.strip().split(" -> ")
        if (data[0] == "broadcaster") {
            broadcastArray = ArrayList(data[1].split(", "))
        } else {
            moduleMapping[data[0].slice(1..(data[0].length - 1))] = Module(current.strip())
        }
        current = readLine()
    }

    for ((key, value) in moduleMapping) {
        for (output in value.outputs) {
            if (moduleMapping.contains(output) && moduleMapping[output]!!.type == '&') {
                moduleMapping[output]!!.amem[key] = Signal.Low
            }
        }
    }

    var workQ = ArrayList<Triple<String, String, Signal>>()

    var low = 0
    var high = 0

    for (r in 1..1000) {
        low += 1
        for (target in broadcastArray) {
            workQ.add(Triple("broadcaster", target, Signal.Low))
        }
        while (workQ.size > 0) {
            val (start, end, signal) = workQ.removeAt(0)
            when (signal) {
                Signal.Low -> low += 1
                Signal.High -> high += 1
            }

            if (!moduleMapping.contains(end)) {
                continue
            }
            moduleMapping[end]!!.operate(workQ, start, signal)
        }
    }
    println(low * high)
}
