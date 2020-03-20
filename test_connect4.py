import unittest

from connect4 import Minmax
class MyTestCase(unittest.TestCase):
    def test_count_each_row_adjacent(self):
        minmax = Minmax(6, 7)

        row_symbol = ['x', 'o','o','o','x','x','o','o','o','o','x','o','o']
        ans = minmax.count_each_row_adjacent(row_symbol, 'o')
        print(ans)
        self.assertEqual(ans[2] == 1 and ans[3] ==1 and ans[4]==1, True)

        row_symbol = ['o','o','o','o', 'x','x','o','o','o','o','x','o','o', 'x']
        ans = minmax.count_each_row_adjacent(row_symbol, 'o')
        print(ans)
        self.assertEqual(ans[2] ==1 and ans[3] ==0 and ans[4]==2, True)

        row_symbol =  ['x', 'x', 'o', 'o', 'o', 'o', 'o']
        ans = minmax.count_each_row_adjacent(row_symbol, 'o')

        print(ans)
    def test_row_terminate(self):
        board = ['x', 'x', 'o', 'o', 'o', 'o', 'o']
        minmax = Minmax(7)

        print(minmax.row_test(board, ['']))

    def test_get_digonal(self):
        board = [['x','x','o'],
                 ['o','x','o'],
                 ['x','x','o'],
                 ['x','x','x']]
        minmax = Minmax(4, 3)

        diagonal = minmax.get_all_diagonal(board)
        print (diagonal)

        board = [['x','x','o','x','o'],
                 ['o','o','o','x','o'],
                 ['x','x','o','o','o'],
                 ['x','x','x','x','o'],
                 ['x','x','o','x','o']]

        minmax = Minmax(5, 5)
        score = minmax.get_all_diagonal(board)
        print(score)

        board = [['x','x','o','x'],
                 ['o','x','o','x'],
                 ['x','x','o','x']]
        minmax = Minmax(3,4)

        diagonal = minmax.get_all_diagonal(board)
        print (diagonal)

    def test_terminate(self):

        board = [['', 'o', '', '', '', ''],
                 ['o', 'x', '', '', '', ''],
                 ['o', 'o', '', '', '', ''],
                 ['o', 'o', '', '', '', ''],
                 ['x', 'x', '', '', '', ''],
                 ['o', 'x', '', '', '', ''],
                 ['o', 'x', 'x', 'x', 'x', 'x']]

        minmax = Minmax(7,6)

        terminate_ans = minmax.terminal_test(board, [''])
        print(terminate_ans)



    def test_node_utility(self):
        board = [['x','x','o','x','o'],
                 ['o','o','o','x','o'],
                 ['x','x','o','o','o'],
                 ['x','x','x','x','o'],
                 ['x','x','o','x','o']]

        minmax = Minmax(5)

        score = minmax.node_utility(board)
        print(score)

    def test_connect_four_play(self):
        minmax = Minmax(5, 5)
        minmax.run()

if __name__ == '__main__':
    unittest.main()
