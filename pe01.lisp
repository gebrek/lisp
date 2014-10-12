(defparameter pe1
  (reduce #'+ (remove-if-not #'(lambda (x) (or (multiple-of x 3) (multiple-of x 5)))
                             (range 1 999))))

(defun multiple-of (x y)
  (= 0 (rem x y)))

(defun range (a &optional (b 0 b-p))
  (if b-p
      (loop
         for i from a to b
         collect i)
      (loop
         for i from 0 to a
         collect i)))

(defun fib (max)
  (let ((list '(2 1)))
    (loop
       for item = (+ (first list) (second list))
       while (> max item)
       do
         (push item list))
    list)))

(defparameter pe2
  (reduce #'+ (remove-if-not #'evenp (fib 4000000))))

(defparameter pe3-number 600851475143)

(defun prime-p (n)
    (loop
       for i in (range 2 (/ n 2))
       do (print i)
       when (multiple-of n i)
       return nil))
    t))
