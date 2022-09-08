require_relative "board"

def get_input
  input = 0
  until input.size == 2 && IDX[:row].has_key?(input[0].to_sym) && IDX[:column].has_key?(input[1].to_sym)
    input = gets.chomp.downcase
  end
  input
end

board = Board.new
play_order = [WHITE, BLACK]
gameover = false

until gameover do
  for i in (0..1) do
    valid = false
    until valid
      board.draw
      puts "#{play_order[i]}'s turn"
      puts "Select a piece"
      from = get_input
      print "move to? "
      to = get_input
      valid = board.place_piece(from, to, play_order[i])
    end
    gameover = board.check_mate?
  end
end