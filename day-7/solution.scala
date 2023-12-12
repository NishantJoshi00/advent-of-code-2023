import scala.io.StdIn.readLine
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap

object Solution {
  def main(args: Array[String]) = {
    var inputArray = ArrayBuffer.empty[(String, Int)]
    var userInput = readLine()

    while (userInput != null) {
      var words = userInput.split("\\s+")

      words.grouped(2).foreach {
        case Array(card, bid) =>
          inputArray += (card -> bid.toInt)
      }

      userInput = readLine()
    }

    var data = inputArray.map {
      case (value, bid) => (getRanking(value), value, bid)
    }.toList

    data = data.sortWith({
      case ((rank1, str1, _), (rank2, str2, _)) => {
        if (rank1 < rank2) {
          true
        } else if (rank1 > rank2) {
          false
        } else {
          compareCards(str1, str2)
        }
      }
    })
    
    var output = data
      .map({ case (_, deck, bid) => bid })
      // .map({ case (_, deck, bid) => (deck, bid) })
      .zip(Iterator.from(1))
      // .map({ case (left, right) => println(s"$left $right") }) 
      .map({ case (left, right) => left * right }).sum

    println(output)
  }

  def getRanking(data: String): Int = {
    var cardMap = new HashMap[Char, Int]()

    for (c <- data) {
      cardMap.update(c, cardMap.getOrElse(c, 0) + 1)
    }

    var values = cardMap.values

    var length = values.count((_) => true)
    var max = values.max
    
    (max, length) match {
      case (5, _) => 6
      case (4, _) => 5
      case (3, 2) => 4
      case (3, _) => 3
      case (2, 3) => 2
      case (2, _) => 1
      case (_, _) => 0
    }
  }

  def compareCards(left: String, right: String): Boolean = {
    var array = left.zip(right).map({
      case (c1, c2) => {
        var lc = c1 match {
          case 'A' => 14
          case 'K' => 13
          case 'Q' => 12
          case 'J' => 11
          case 'T' => 10
          case num => num.asDigit
        }

        var rc = c2 match {
          case 'A' => 14
          case 'K' => 13
          case 'Q' => 12
          case 'J' => 11
          case 'T' => 10
          case num => num.asDigit
        }
        (lc, rc)
    }})

    // array.foreach(println)

    for ((left,right) <- array) {
      if (left < right) {
        return true
      } else if (right < left) {
        return false
      }
    }

    true
  }
}
