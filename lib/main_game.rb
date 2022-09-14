require_relative 'board'

def get_input(grid, from = true)
  input = 0
  until input.size == 2 && IDX[:row].has_key?(input[0].to_sym) && IDX[:column].has_key?(input[1].to_sym) 
    input = gets.chomp.downcase
  end
  cell = grid[IDX[:row][input[0].downcase.to_sym]][IDX[:column][input[1].downcase.to_sym]]
  if cell == EMPTY && from
    puts "Select a valid piece"
    input = get_input(grid)
  end
  print "#{cell} " if from
  input
end

board = Board.new
play_order = [WHITE, BLACK]
gameover = false
until gameover
  for i in (0..1) do
    valid = false
    until valid
      board.draw
      puts "#{play_order[i].capitalize}'s turn, select a piece"
      from = get_input(board.grid)
      print 'move to? '
      to = get_input(board.grid, false)
      valid = board.place_piece(from, to, play_order[i])
    end
    gameover = board.check_mate?
    break if gameover
  end
end
board.draw
puts 'Gameover'
