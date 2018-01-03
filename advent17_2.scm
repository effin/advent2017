(define (nextPos currPosIdx len steps)
  (modulo (+ currPosIdx steps) len))

(define (spinlock valAfterZero currPosIdx v steps)
  (cons (if (equal? 0 currPosIdx) v valAfterZero) (cons (+ 1 currPosIdx) '())))

(define (solve c state)
  (if (equal? 50000000 c)
      (car state)
      (solve (+ c 1) (spinlock (car state) (nextPos (cadr state) (+ c 1) 314) (+ c 1) 314))))

(solve 1 '(1 1))