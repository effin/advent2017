(ns advent9)
(use '[clojure.string :only [index-of starts-with?]])

(defn cleanexclamationpoints [s]
  (if (= nil (index-of s "!"))
    s
    (str (subs s 0 (index-of s "!")) (cleanexclamationpoints (subs s (+ 2 (index-of s "!")))))))

(defn removecrap [s]
  (if (= nil (index-of s "<"))
    s
    (str (subs s 0 (index-of s "<")) (removecrap (subs s (+ 1 (index-of s ">" (index-of s "<"))))))))

(defn groupsum
  ([s d]
   (if (starts-with? s "{")
     (groupsum (subs s 1) (+ 1 d))
     (if (starts-with? s ",")
       (groupsum (subs s 1) d)
       (if (starts-with? s "}")
         (+ d (groupsum (subs s 1) (- d 1)))
         0))))
  ([s] (groupsum s 0)))

(println (groupsum (removecrap (cleanexclamationpoints (slurp "input9.txt")))))

(defn removecrapkeepbrackets [s]
  (if (= nil (index-of s "<"))
    s
    (str (subs s 0 (+ 1 (index-of s "<"))) (removecrapkeepbrackets (subs s (index-of s ">" (index-of s "<")))))))

(println (- (count (cleanexclamationpoints (slurp "input9.txt"))) (count (removecrapkeepbrackets (cleanexclamationpoints (slurp "input9.txt"))))))

