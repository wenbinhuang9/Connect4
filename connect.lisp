

;0 open, 1 player1, 2 player 2
(defparameter board '(0 0 0 0 0
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

(defun run (player)
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


(defun node_utility (board)
    ()
)
(defun player_utility (board player)
    ()
)

(defun terminal_test(board)
    (if (or (eq (test-horizontal-win board player1) 1)
            (eq (test-horizontal-win board player2) 1)
            (eq (test-vertical-win board player1) 1)
            (eq (test-vertical-win board player2) 1)
            (eq (test-diagonal-win_2 board player1) 1)
            (eq (test-diagonal-win_2 board player2) 1)
            (eq (test-diagonal-win_1 board player1) 1)
            (eq (test-diagonal-win_1 board player2) 1))
      1
      ;else
      nil
   )
)

(defun test-horizontal-win (board player)
	(let()
    	(loop for r from 0 to (- row 1)
			do(
				loop for c from 0 to (- col 4)
					do(
						if ( and (equal (get_e r c) player)
				       		      (equal (get_e r (+ c 1)) player)
				   	      	      (equal (get_e r (+ c 2)) player)
				          	      (equal (get_e r (+ c 3)) player) )
							;(setf result 1)
							(return-from test-horizontal-win 1)
					)
			)
	    ) ; end of test horizontal wins for player 1
		(return-from test-horizontal-win nil)
	)
)

(defun test-vertical-win (board player)
	(let()
    	(loop for c from 0 to (- col 1)
			do(
				loop for r from 0 to (- row 4)
					do(
						if ( and (equal (get_e r c) player)
				       		      (equal (get_e (+ r 1) c) player)
				   	      	      (equal (get_e (+ r 2) c) player)
				          	      (equal (get_e (+ r 3) c ) player) )
							;(setf result 1)
							(return-from test-vertical-win 1)
					)
			)
	    ) ; end of test horizontal wins for player
		(return-from test-vertical-win nil)
	)
)

(defun test-diagonal-win_1 (board player)
	(let()
    	(loop for r from 0 to (- row 4)
			do(
				loop for c from 0 to (- col 4)
					do(
						if ( and (equal (get_e r c) player)
				       		      (equal (get_e (+ r 1) (+ c 1)) player)
				   	      	      (equal (get_e (+ r 2) (+ c 2)) player)
				          	      (equal (get_e (+ r 3) (+ c 3)) player) )
							;(setf result 1)
							(return-from test-diagonal-win_1 1)
					)
			)
	    ) ; end of test horizontal wins for player 1
		(return-from test-diagonal-win_1 nil)
	)
)

(defun test-diagonal-win_2 (board player)
	(let()
    	(loop for r from 0 to (- row 4)
			do(
				loop for c from (- col 1) downto 3
					do(
						if ( and (equal (get_e r c) player)
				       		      (equal (get_e (+ r 1) (- c 1)) player)
				   	      	      (equal (get_e (+ r 2) (- c 2)) player)
				          	      (equal (get_e (+ r 3) (- c 3)) player) )
							;(setf result 1)
							(return-from test-diagonal-win_2 1)
					)
			)
	    ) ; end of test horizontal wins for player
		(return-from test-diagonal-win_2 nil)
	)
)
