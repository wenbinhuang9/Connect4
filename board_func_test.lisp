;0 open, 1 player1, 2 player 2
(defparameter board '(20 0 0 0 0
                      0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0))

(defparameter row 5)
(defparameter col 5)
(defparameter player1 1)
(defparameter player2 2)

(defun pos (i j)
    (+ (* row i) j)
)
(defun get_e (i j)
    (nth (pos i j) board)
)
(defun set_e (i j player)
    (setf (nth (pos i j) board) player)
)

(print (get_e 0 0))
(print (get_e 4 4))
(print (set_e 4 4 10))
(print (get_e 4 4))
(print board)