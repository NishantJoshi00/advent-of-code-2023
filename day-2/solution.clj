(require '[clojure.string :as str])

;                 +--------- red
;                 |  +------ green
;                 |  |  +--- blue
(def collection [12 13 14])

(defn buffer-print [data] (let [_ (println data)] data))

(defn compare-collection [data]
  (let [[red green blue] data
        [max_red max_green max_blue] collection]
    (cond
      (> red max_red) false
      (> green max_green) false
      (> blue max_blue) false
      :else true)))

(defn add-vector [v1 v2]
  (map #(reduce + %1) (map vector v1 v2)))

(defn idx-game [game]
  (Integer/parseInt (get (str/split game #" ") 1)))

(defn fit-cubes [data-set current]
  (let [[cnt color] (str/split current #" ")]
    (add-vector data-set (case color
                           "red" [(Integer/parseInt cnt) 0 0]
                           "green" [0 (Integer/parseInt cnt) 0]
                           "blue"  [0 0 (Integer/parseInt cnt)]))))

(defn get-cubes [data]
  (compare-collection
   (reduce fit-cubes [0 0 0]
           (str/split data #", "))))

(defn get-max-cubes [reveal]
  (map get-cubes (str/split reveal #"; ")))

(defrecord Game [game state])

(defn read-input []
  (try
    (let [[game data] (str/split (read-line) #": ")]
      [1, (->Game (idx-game game) (reduce #(and %1 %2) (get-max-cubes data)))])
    (catch Exception _ [0])))

(defn input-loop [my-map]
  (let [[state data] (read-input)]
    (if (= state 0)
      my-map
      (recur
       (if (:state data)
         (concat [(:game data)] my-map)
         my-map)))))

(defn main []
  ; (println (read-input)) (println (read-input)))
  (println (reduce + (input-loop []))))

(main)
