require_relative 'board'

def get_input(board, player, from = true)
  input = 0
  command = ["save", "delete", "load"]
  puts "select a piece " if from
  until input.size == 2 && IDX[:row].has_key?(input[0].to_sym) && IDX[:column].has_key?(input[1].to_sym) || command.include?(input)
    input = gets.chomp.downcase
  end
  if command.include? input
    case input
    when 'save'
      save_game(board.grid, player)
      return input = get_input(board, player)
    when 'delete'
      delete_save
      return input = get_input(board, player)
    else 
      loaded = load_game
      unless loaded
        puts "Missing save"  
        return input = get_input(board, player)
      end
      @current_player = loaded[:player]
      board.load_board(loaded[:grid])
      board.draw
      print "#{@current_player.capitalize}'s turn, "
      return input = get_input(board, player)
    end
  end
  cell = board.grid[IDX[:row][input[0].downcase.to_sym]][IDX[:column][input[1].downcase.to_sym]]
  if cell == EMPTY && from
    print "Invalid piece, "
    return input = get_input(board, player)
  end
  print "#{cell} " if from
  input
end

board = Board.new
@current_player = WHITE
gameover = false
puts "You can 'save', 'load' or 'delete' the game between turns"

until gameover
  valid = false
  until valid
    board.draw
    print "#{@current_player.capitalize}'s turn, "
    from = get_input(board, @current_player)
    print 'to? '
    to = get_input(board, @current_player, false)
    valid = board.place_piece(from, to, @current_player)
  end
  @current_player = @current_player == WHITE ? BLACK : WHITE
  gameover = board.check_mate?
end
board.draw
puts 'Gameover'
