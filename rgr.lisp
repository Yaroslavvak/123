(defun calculate-sequence ()
  (loop for i from 1 to 30
        with prev = 0d0
        for curr = (cond
                     ((= i 1) 1d0)
                     ((<= i 15) (+ (* prev 2d0) (* 5d0 (sin (float i 1d0)))))
                     ((= i 16) 2d0)
                     (t (+ (/ prev 2d0) (* 5d0 (cos (float i 1d0))))))
        do (setf prev curr)
        collect (cons i curr)))

(defun print-results (data)
  (format t "~% i |        F(i)~%---|------------------~%")
  (dolist (pair data)
    (format t "~2d | ~14,6f~%" (car pair) (cdr pair)))
  (values))

(print-results (calculate-sequence))
