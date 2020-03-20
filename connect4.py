import sys

## reference  https://github.com/noxsicarius/Connect4-Lisp
## http://blog.gamesolver.org/solving-connect-four/09-anticipate-losing-moves/
## one of naive method is going to use limited depeening skills?
class Minmax():
    def __init__(self, row, col):
        self.row = row
        self.col = col
        self.board = [[' ' for j in range(self.col)] for i in range(self.row)]
        self.player1 = "Maria"
        self.player2 = "Michael"
        self.player1_x = 'x'
        self.player2_o = 'o'

    def run(self):
        board = self.board
        cur_paler = self.player1
        count = 0
        while self.terminal_test(board) == False:
            if count == 3:
                return
                print(count)
            count += 1
            i, j = self.play(board, cur_paler)
            self.fill_board(board, cur_paler, i, j )
            cur_paler = self.nextPlayer(cur_paler)
            self.print_board(board)
            print("%n")
        self.print_board(board)
        self.print_winner(board)
        return

    def print_board(self, board):
        for row in board:
            print(row)

    def nextPlayer(self, player):
        return self.player1 if player == self.player2 else self.player2

    def play(self, board, player):
        if player == self.player1:
            maxx, pos = self.max_value(board, 5)
            return pos

        minxx, pos = self.min_value(board, 3)

        return pos

    def actions(self, board):
        col = len(board[0])
        actions_list = []

        for c in range(col):
            if board[0][c] == ' ':
                actions_list.append(self.get_actions_in_each_col(board, c))

        return actions_list

    def get_actions_in_each_col(self, board, col):
        row = len(board)

        i = row - 1
        while i >=0:
            if board[i][col] == ' ':
                return (i, col)
            i -= 1
        return  None
    def print_game_result(self, actions_path):
        board = [[' ' for j in range(self.col)] for i in range(self.row)]
        for i, j, player in actions_path:
            board[i][j] == player

        print("final board")
        print(board)

        self.print_winner(board)

    def print_winner(self, board):

        win_symbol = [' ']

        self.terminal_test(board, win_symbol)

        if win_symbol[0] == self.player1_x:
            print("player {0} win".format(self.player1))
        elif win_symbol[0] ==self.player2_o:
            print("player {0} win".format(self.player2))
        else:
            print("no one wins")

    def fill_board(self, board, player, i, j):
        if player == self.player1:
            player = self.player1_x
        if player == self.player2:
            player = self.player2_o

        board[i][j] = player
    def unfill_board(self, board, player, i, j):
        board[i][j] = ' '

    def max_value(self, board, max_iteration):
        if max_iteration == 0 or self.terminal_test(board):
            return (self.node_utility(board),[])
        maxx = -sys.maxint - 1
        maxx_pos = (-1, -1)
        for i, j in self.actions(board):
            self.fill_board(board, self.player1_x, i, j)
            cur_value , pos= self.min_value(board, max_iteration - 1)
            if cur_value > maxx:
                maxx = cur_value
                maxx_pos = (i, j)
            self.unfill_board(board, self.player1_x, i, j)

        return (maxx, maxx_pos)

    def min_value(self, board, max_iteration):
        if max_iteration == 0 or self.terminal_test(board):
            return (self.node_utility(board), [])

        minx =sys.maxint
        min_pos = (-1, -1)

        for i, j in self.actions(board):
            self.fill_board(board, self.player2_o, i, j)
            cur_value, pos = self.max_value(board, max_iteration - 1)
            if cur_value < minx:
                minx = cur_value
                min_pos = (i, j)
            self.unfill_board(board, self.player2_o, i, j)

        return (minx, min_pos)


    def node_utility(self, board):
        two_adjacent, three_adjacent, four_adjacent = self.count_num_of_adjacent_by_row_or_col(board, self.player1_x)
        paler1_socre = two_adjacent + three_adjacent * 100 + four_adjacent * (10000)

        two_adjacent, three_adjacent, four_adjacent = self.count_num_of_adjacent_by_row_or_col(board, self.player2_o)
        paler2_socre = two_adjacent + three_adjacent * 100 + four_adjacent * (10000)

        return paler1_socre - paler2_socre

    def count_num_of_adjacent_by_row_or_col(self, board, symbol):
        four_adjacent, three_adjacent, two_adjacent = 0, 0, 0
        row = len(board)
        col = len(board[0])

        ## count for each row
        for i in range(row):
            ans = self.count_each_row_adjacent(board[i], symbol)
            four_adjacent += ans[4]
            three_adjacent += ans[3]
            two_adjacent += ans[2]
        ## count for each col
        for i in range(col):
            col_board = [board[j][i] for j in range(row)]
            ans = self.count_each_row_adjacent(col_board, symbol)
            four_adjacent += ans[4]
            three_adjacent += ans[3]
            two_adjacent += ans[2]
        ## count for diagonal
        for diagonal_board in self.get_all_diagonal(board):
            ans = self.count_each_row_adjacent(diagonal_board, symbol)
            four_adjacent += ans[4]
            three_adjacent += ans[3]
            two_adjacent += ans[2]

        return (two_adjacent, three_adjacent, four_adjacent)





    def get_all_diagonal(self, board):
        row = len(board)
        col = len(board[0])
        diagonal_list = []

        for c in range(col):
            diagonal_len = c - 0 + 1
            diagonal_list.append([board[0 + n][c- n] for n in range(diagonal_len)])

        for r in range(1, row):
            diagonal_len = row - r
            diagonal_list.append([board[r + n][col -1 - n] for n in range(diagonal_len)])

        return diagonal_list

    ## oh fuck, the code here is not readable
    def count_each_row_adjacent(self, board_row, symbol):
        try:
            i, j = -1, 0
            ans = [0 for i in range(self.row)]
            while j < len(board_row):
                if board_row[j] != symbol:
                    ans[j - i - 1] +=1
                    i = j
                j +=1

            if board_row[j - 1] == symbol:
                 ans[j - i - 1] += 1
            return ans
        except:
            print("board_row={0}".format(board_row))
            print("symbol={0}".format(symbol))
            raise

    def terminal_test(self, board, win_symbol = [' ']):
        if self.is_full(board) or self.row_test(board, win_symbol) or self.col_test(board,win_symbol) or self.diagonal_test(board,win_symbol):
            return True
        return False

    def is_full(self, board):
        row = len(board)
        col = len(board[0])

        for i in range(row):
            for j in range(col):
                if board[i][j] == ' ':
                    return False
        return True

    def row_test(self, board, win_symbol):
        row = len(board)
        col = len(board[0])
        for c in range(col):
            for r in range(row - 3):
                if board[r][c]!=' ' and board[r][c] == board[r + 1][c]== board[r + 2][c]==board[r + 3][c]:
                    win_symbol[0] = board[r][c]
                    return True

        return False

    def col_test(self, board, win_symbol):
        row = len(board)
        col = len(board[0])
        for r in range(row):
            for c in range(col - 3):
                if board[r][c]!=' ' and board[r][c] == board[r][c + 1] == board[r][c + 2] == board[r][c + 3]:
                    win_symbol[0] = board[r][c]

                    return True

        return False

    def diagonal_test(self, board, win_symbol):
        row = len(board)
        col = len(board[0])

        for c in range(col):
            diagonal_len = c - 0 + 1
            if diagonal_len >= 4 and self.single_diagonal_test(board, 0, c, diagonal_len, win_symbol):

                return True

        for r in range(1, row):
            diagonal_len = col - r
            if diagonal_len >=4 and self.single_diagonal_test(board, r, col -1, diagonal_len, win_symbol):

                return True

        return False

    def single_diagonal_test(self, board, i, j, length, win_symbol):
        try:
            for n in range(length - 3):
                row = i + n
                col = j - n
                if board[row][col] != ' ' and board[row][col]==board[row+1][col-1]==board[row+2][col-2]==board[row+3][col-3]:
                    win_symbol[0] = board[row][col]
                    return True

            return False
        except:
            print("row={0}|col={1}|length={2}".format(i, j, length))
            print(board)
            raise