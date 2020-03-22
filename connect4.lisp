;; https://rextester.com/DSCT2165

;---------define global variable----------
;0 open, 1 player1, 2 player 2

(defparameter board '(0 0 0 0 0
                      0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0
					  0 0 0 0 0))

(defparameter empty 0)
(defparameter player1 1)
(defparameter player2 2)
(defparameter row 5)
(defparameter col 5)

; limit max-depth to explore minimax nodes
(defparameter max_depth 3)
;---------start the game as following code-------------
; start game from here
(defun connect-4 ()
    (start-game player1)
)

(defun start-game(player)
    (run-game player)
)

(defun run-game (player)
    (if (game_over board)
        (return-from run-game (print "Game Over"))
    ;else
        (let()
            (play board player)
            (run-game (next_player player))
        )
    )

)

(defun play (board player)
    (
    if (= player player1)
        (maxx board max_depth)
    ;else
        (mini board max_depth)
    )
)

(defun next_player (cur_player)
   (- 3 cur_player)
)


;---------core function minimax implementation -------------

(defun mini(board depth)
    (if (or (game_over board) (eq depth 0))
        (heuristic_score board)
    ;else
        (let((curmin 10000)
             (r_min -1)
             (c_min -1)
            )
            (loop for c from 0 to (- col 1)
                do(
                    if (can_be_filled c)
                        (let ((r (find_row_to_fill c)))
                            ;invoke maxx function here
                            (setf ans (maxx (fill_board c player2) (- depth 1)))
                            ;get minimum score
                            (if (< ans curmin)
                                (let()
                                    (setf curmin ans)
                                    (setf r_min r)
                                    (setf c_min c)
                                )
                            )
                            (unfill_board r c)
                        )
                )
            )
           (return-from mini (minimax_return r_min c_min curmin depth player2))
        )
    )
)


(defun maxx (board depth)
    (if (or (game_over board) (eq depth 0))
        (heuristic_score board)
    ;else
        (let((curmax -10000)
             (r_max -1)
             (c_max -1)
            )

            (loop for c from 0 to (- col 1)
                do(
                    if (can_be_filled c)
                        (let ((r (find_row_to_fill c)))
                        (setf ans (mini (fill_board c player1) (- depth 1)))
                            (if (> ans curmax)
                                (let ()
                                     (setf curmax ans)
                                     (setf c_max c)

                                     (setf r_max r)
                                    )
                              )
                            ;else
                            (unfill_board r c)
                        )
                )
            )
            (return-from maxx (minimax_return r_max c_max curmax depth player1))
        )
    )
)

;--------define basic operations for the board-------------
;mapping two dimensional index to one dimension index
(defun pos (i j)
    (+ (* row i) j)
)

;get element from board
(defun get_e (i j)
    (nth (pos i j) board)
)
;set element to board
(defun set_e (i j player)
    (setf (nth (pos i j) board) player)
)

;get sublist from a list
(defun slice (lst start count)
        (if (> start 0)
            (slice (cdr lst) (- start 1) count)
            (get-n-items lst count)))

(defun index (list i)
   (nth i list)
)

(defun get-n-items
   (lst num)
        (if (> num 0)
            (cons (car lst) (get-n-items (cdr lst) (- num 1))
            )
            '()
         ))



(defun fill_board (c player)
    (if   (set_e (find_row_to_fill c) c player)
        board
    )
)
(defun find_row_to_fill (c)
    (loop for r from (- row 1) downto 0
        do (
            if (eq (get_e r c) 0)
                (return-from find_row_to_fill r)
        )
    )
)

(defun can_be_filled (c)
    (if (= (get_e 0 c) empty)
        1
     ;else
        nil
    )
)

(defun unfill_board (r c)
    (set_e r c empty)
)

;-----------cal heuristic score for each player-----------
(defun heuristic_score (board)
    (- (player_utility board player1) (player_utility board player2))
)
(defun player_utility (board player)
       (+  (get_diagonal_score player) (+ (get_row_score player) (get_col_score player)))
)

(defun cal_heuristic(line player)
	(let()
    	(loop for i from 0 to (- (list-length line) 1)
			do(
                if (and (eq empty (index line i))
                        (eq player (index line (+ i 1)))
                        (eq player (index line (+ i 2)))
                        (eq player (index line (+ i 3))))
                    (return-from cal_heuristic 100)

                    ;else
                    (if (and (eq empty (index line i))
                             (eq player (index line (+ i 1)))
                             (eq player (index line (+ i 2))))

                            (return-from cal_heuristic 1)
                     )
			)
	    ) ; end of test horizontal wins for player 1
        (return-from cal_heuristic 0)
	)
)

(defun get_row_score (player)
    (+ (get_row_score_recursive 0 player)  (get_reversed_row_score_recursive 0 player))
)

(defun get_reversed_row_score_recursive(i player)
	(if (< i row)
        (+  (cal_heuristic (reverse (slice board (* 5 i) col)) player) (get_reversed_row_score_recursive (+ i 1) player))
         0
     )
)


(defun get_row_score_recursive (i player)
	(if (< i row)
        (+  (cal_heuristic (slice board (* 5 i) col) player) (get_row_score_recursive (+ i 1) player))
        0
    )
)
(defun get_col_score (player)
    (get_col_score_recursive 0 player)
)
(defun get_col_score_recursive (i player)
	(if (< i col)
        (+  (cal_heuristic (get_col i) player) (get_col_score_recursive (+ i 1) player))
        0
    )
)

(defun get_col (i)
    (if (index board i )
        (cons  (index board i ) (get_col (+ i col)))
        '()
    )
)

(defun get_diagonal_score (player)
    (+
        (+ (get_diagonal_score_recursive_1 (- row 1) 0 player) (get_diagonal_score_recursive_2 0 1 player))
        (+ (get_diagonal_score_recursive_3 0 0 player) (get_diagonal_score_recursive_4 1 (- col 1) player ))
    )
)

(defun get_diagonal_score_recursive_1 (i j player)
   (if (< i 0)
       0
       (+ (cal_heuristic (get_left_diagonal i j) player)  (get_diagonal_score_recursive_1 (- i 1) j player))
   )
)

(defun get_diagonal_score_recursive_2 (i j player)
   (if (< j col)
       (+ (cal_heuristic (get_left_diagonal i j) player)  (get_diagonal_score_recursive_2 i (+ j 1) player))
       0
   )
)

(defun get_diagonal_score_recursive_3 (i j player)
   (if (< j col)
       (+ (cal_heuristic (get_right_diagonal i j) player)  (get_diagonal_score_recursive_3 i (+ j 1) player))
       0
   )
)

(defun get_diagonal_score_recursive_4 (i j player)
   (if (< i row)
       (+ (cal_heuristic (get_right_diagonal i j) player)  (get_diagonal_score_recursive_4 (+ i 1) j player))
       0
   )
)


(defun get_left_diagonal (i j)
    (if (get_e i j)
        (cons (get_e i j) (get_left_diagonal (+ i 1) (+ j 1)))
        '()
    )
)

(defun get_right_diagonal (i j)
    (if (get_e i j)
        (cons (get_e i j) (get_right_diagonal (+ i 1) (- j 1)))
        '()
    )
)

(defun minimax_return (r c curmax depth player)
    (if (= depth max_depth)
        (let()
           (set_e r c player)
           (format t "player ~D is playing"  player)
           (print_board board)
           (terpri)
        )

     ;else
        curmax
    )
)
;-----------------board print function------------------------

(defun print_board (board)
    (print_board_recursive board 0
    )
)
(defun print_board_recursive (board r)
       (if (< r row)
            (let()
                (print_row board r)
                ( print_board_recursive  board (+ r 1))
            )
       )
)

(defun print_row (board r)
    (let()

        (print (slice board (* r row) col))
        (terpri)
    )
)

;--------------game over test-------------
(defun winner (board)
       (if (or (eq (test-horizontal-win board player1) 1)
            (eq (test-vertical-win board player1) 1)
            (eq (test-diagonal-win_2 board player1) 1)
            (eq (test-diagonal-win_1 board player1) 1)
            )
            (print "player1 wins")
        ;else
        (
            if (or
                (eq (test-horizontal-win board player2) 1)
                (eq (test-vertical-win board player2) 1)
                (eq (test-diagonal-win_2 board player2) 1)
                (eq (test-diagonal-win_1 board player2) 1)
                )
                (print "player2 wins")
            ;else
                (print "no one wins")
        )

        )
)

(defun game_over(board)

    (if (or (eq (test-horizontal-win board player1) 1)
            (eq (test-horizontal-win board player2) 1)
            (eq (test-vertical-win board player1) 1)
            (eq (test-vertical-win board player2) 1)
            (eq (test-diagonal-win_2 board player1) 1)
            (eq (test-diagonal-win_2 board player2) 1)
            (eq (test-diagonal-win_1 board player1) 1)
            (eq (test-diagonal-win_1 board player2) 1)
            )
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
	    )
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

(connect-4)
(winner board)

