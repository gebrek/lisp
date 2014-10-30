(defparameter *ex-eq*
'(= 0
    (+  (/ (- n0 n1) r1)
        (/ n0 r2)
        (/ (- n0 n2) r3))))

(defparameter *ex-expr*                 ; (caddr *ex-eq*)
  '(+   (/ (- n0 n1) r1)
        (/ n0 r2)
        (/ (- n0 n2) r3)))

;;;  sep-terms of right side
;;;  ===>
;;;  (+ (/ n0 r1)
;;;     (- (/ n1 r1))
;;;     (/ n0 r2)
;;;     (/ n0 r3)
;;;     (- (/ n2 r3)))

(defun solve-eqtn-for (equation variable)
  ())

;; (/ a b) => (* a (/ b))
;; assumes all operators have been expanded
(defun un-operate (expr)                ; / and - are lies!
  (cond ((atom expr) expr)
        ((eq (car expr) '/)
         `(* ,(un-operate (cadr expr)) (/ ,(un-operate (caddr expr)))))
        ((eq (car expr) '-)
         `(+ ,(un-operate (cadr expr)) (- ,(un-operate (caddr expr)))))
        (t
         `(,(car expr) ,(un-operate (cadr expr)) ,(un-operate (caddr expr))))))

;; (/ a b c) => (/ a (/ b c))
(defun expand-operator (expr)
  (let ((op (car expr)))
    (cond ((= (length expr) 3) expr)
          ((or (eq op '+) (eq op '-) (eq op '/) (eq op '*))
           (expand-operator `(,op (,op ,(cadr expr) ,(caddr expr)) ,@(cdddr expr))))
          (t nil))))

(defun communicate (expr)
  (let ((op (car expr)) (x (cadr expr)) (y (caddr expr)))
    (cond ((eql op '+) `(,op ,y ,x))
          ((eql op '*) `(,op ,y ,x))
          (t expr))))

;; meant for after processing
(defun flat-expr-p (expr)
  (let ((op (car expr)))
    (cond ((equal op '/) t)
          ((equal op '-) t)
          ((equal op '+) nil)
          ((equal op '*) nil))))

;; (* a
;;    (+ b c)
;; ===>
;; (+ (* a b)
;;    (* a c)
(defun distribute (expr)
  (let ((op (car expr)) (x (cadr expr)) (y (caddr expr)))
    (cond ((eql op '*)
           (cond ((and (flat-expr-p x) (flat-expr-p y))
                  expr)
                 ((and (flat-expr-p x) (not (flat-expr-p y)))
                  `(,(car y) (,op x (cadr y)) (,op x (caddr y))))
                 ((and (not (flat-expr-p x)) (flat-expr-p y))
                  `(,(car x) (,op y (cadr x)) (,op y (caddr x))))
                 ((and (not (flat-expr-p x)) (not (flat-expr-p y)))
                  `(,(car y) (,op x (cadr y)) (,op x (caddr y))))
                 (t 'probably-should-never-happen)))
          (t expr))))
;; bluh doesn't work yet
