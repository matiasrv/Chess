require_relative "aux"

class Board
  attr_accessor :grid

  def initialize
    @current_color, @current_oposite, @current_piece = nil
    @grid = []
    @grid.push [ PIECE[BLACK][:rook], PIECE[BLACK][:knight], PIECE[BLACK][:bishop], PIECE[BLACK][:queen], PIECE[BLACK][:king], PIECE[BLACK][:bishop], PIECE[BLACK][:knight] ,PIECE[BLACK][:rook]] 
    @grid.push [ PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn] ]
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push [ PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn]] 
    @grid.push [ PIECE[WHITE][:rook], PIECE[WHITE][:knight], PIECE[WHITE][:bishop], PIECE[WHITE][:queen], PIECE[WHITE][:king], PIECE[WHITE][:bishop], PIECE[WHITE][:knight] ,PIECE[WHITE][:rook]] 
  end

  def draw
    char = "H"
    @grid.reverse.each_with_index do |row, y| 
      print "\n" if y != 0
      print char, " "; char = (char.ord - 1).chr 
      row.each_with_index do |p, x| 
        (x + y) % 2 == 0 ? print(p.bg_black) : print(p.bg_gray)
      end
    end
    print "\n"
    puts "  12345678", "" 
  end

  def validate_play(start, finish, player)
    @current_color, @current_piece, @current_oposite = :none
    return false if start == finish
    puts @grid[start.first][start.last]
    PIECE.each do |clr, hash|
      hash.each do |piece, char|
        if char == @grid[start.first][start.last]
          @current_color = clr
          @current_piece = piece
        end
      end
    end
    @current_color == WHITE ? @current_oposite = "black".to_sym : @current_oposite = WHITE
    return false if @current_color != player
    if @current_piece == :pawn #special case black/white
      return false if (start[0] - finish[0]).abs > 1 && 
        (start[0] != IDX[:row][:g] && @current_color == WHITE) ||
        (start[0] != IDX[:row][:b] && @current_color == BLACK)
      valid_dir = TRANS[@current_piece][@current_color].select { |n| (start.add(n)).between?(start, finish) }
    else
      valid_dir = TRANS[@current_piece].select { |n| (start.add(n)).between?(start, finish) }
    end
    return false if valid_dir.empty?
    if (@current_piece == :king || @current_piece == :knight || @current_piece == :pawn)
      return false if valid_dir.select { |dir| start.add(dir) == finish }.empty?
      return true
    end
    points = [[start]] 
    skip = []
    until points.empty? do
      return false if skip.size == valid_dir.size
      for i in (0...points.size) do
        next if skip.include?(i)
        point = points[i].last.add(valid_dir[i])
        if point.between?(start,finish) && @grid[point.first][point.last] == EMPTY
          points[i].push(point)
        else
          if point == finish && PIECE[@current_oposite].has_value?(@grid[finish.first][finish.last]) 
            points[i].push(point) 
          else
            skip << i
          end
        end
      end
      points.each { |arr| return true if arr.include?finish }
    end
    false
  end

  def place_piece(start, finish, player)
    puts "player #{player}"
    s = [IDX[:row][start[0].downcase.to_sym], IDX[:column][start[1].downcase.to_sym]]
    f = [IDX[:row][finish[0].downcase.to_sym], IDX[:column][finish[1].downcase.to_sym]]
    valid = validate_play(s, f, player)
    puts "#{@current_color} #{@current_piece} from #{start} to #{finish} V?#{valid}"
    return false unless valid
    @grid[s.first][s.last] = EMPTY
    @grid[f.first][f.last] = PIECE[@current_color][@current_piece]
  end

  def count(color)
    @grid.inject(0) { |a, b| sum = a + b.count { |c| PIECE[color].has_value?c } }
  end

  def check_mate?
    return false unless check?    
  end

  def check?
    false
  end
end
