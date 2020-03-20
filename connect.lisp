


(defparameter board '(0 0 0 0 0
                      0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0))

(defparameter player1 1)
(defparameter player2 2)


(run (player)
    (while (terminal_test board)
        (
        play((next player))
        )
    )
)

(defun next (player)
    (if (eq player 1)
        2
    ;else
        1
    )
)
(defun play (board player)
    (
    if (equal player player1)
        (max board 5)
    ;else
        (min board 5)
    )
)

(defun max(board iteration)
    (if (or terminal_test(board) (eq iteration 0))
        (node_utility(board))
     (loop for x in actions()
        do (
            find_max board
        ))
    )
)

(defun find_max(board)
    ()
)

(defun min(board iteration)
    (if (or terminal_test(board) (eq iteration 0))
        (node_utility(board))
     (loop for x in actions()
        do (
            find_min board
        ))
    )
)

(defun find_min (board)
    (

    )
)

(defun fill_board(board player i j )
    ()
)
(defun actions(board)
    ()
)
(defun min(board iteration) (
        ))

(defun terminal_test(board) (
        ))

(defun node_utility ()
    ()
)

(defun test-horizontal-win(board)
	(let()
    	(loop for x from 0 to 3
			do(
				loop for y from 0 to 5
					do(
						if ( and (equal (nth (+ (* 7 y) (+ x 0)) board) 1)
				       		      (equal (nth (+ (* 7 y) (+ x 1)) board) 1)
				   	      	      (equal (nth (+ (* 7 y) (+ x 2)) board) 1)
				          	      (equal (nth (+ (* 7 y) (+ x 3)) board) 1) )
							;(setf result 1)
							(return-from test-player1-win-horizontal t)
					)
			)
	    ) ; end of test horizontal wins for player 1
		(return-from test-player1-win-horizontal nil)
	)
)