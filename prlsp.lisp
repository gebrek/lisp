(with-open-file (file-in "ls.txt" :if-does-not-exist nil)
  (with-open-file (file-out "sorted-ls.txt" :if-exists :supersede :direction :output)
    (print (group-by-type (file-to-list file-in))
           file-out)))

(defun group-by-type (list)
  (mapcar #'filename->cell list))

(defun filename->cell (string)
  (let ((radix (position #\. string :from-end t)))
    (if (null radix)
        (list "NONE" string)
        (list (subseq string (1+ radix)) (subseq string 0 radix)))))

(defun file-to-list (in)
  (let ((list '()))
    (when in
      (loop
         for line = (read-line in nil)
         while line do (push line list)))
    list))

(defun acells->alist (cells-list)
  (let ((alist '()))
    (loop
       for item in cells-list
       do
         (setf alist (add-assoc item alist)))
    alist))

(defun add-assoc (item alist)
  (let ((place (assoc (car item) alist)))
    (if place
        (append place (cdr item))
        (append item alist))))

(with-open-file (file-in "ls.txt" :if-does-not-exist nil)
  (with-open-file (file-out "sorted-ls.txt" :if-exists :supersede :direction :output)
    (acells->alist (group-by-type (file-to-list file-in)))))
