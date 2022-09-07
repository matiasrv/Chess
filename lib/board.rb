require_relative "aux"

class Board
  attr_accessor :grid

  def initialize
    @grid = []
    @grid.push [ PIECE[:black][:rook], PIECE[:black][:knight], PIECE[:black][:bishop], PIECE[:black][:queen], PIECE[:black][:king], PIECE[:black][:bishop], PIECE[:black][:knight] ,PIECE[:black][:rook]] 
    @grid.push [ PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn] ]
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push ( Array.new(8) { EMPTY } )
    @grid.push [ PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn], PIECE[:white][:pawn]] 
    @grid.push [ PIECE[:white][:rook], PIECE[:white][:knight], PIECE[:white][:bishop], PIECE[:white][:queen], PIECE[:white][:king], PIECE[:white][:bishop], PIECE[:white][:knight] ,PIECE[:white][:rook]] 
  end

  def draw
    @grid.each_with_index do |row, y| 
      print "\n" if y != 0 
      row.each_with_index do |p, x| 
        (x + y) % 2 == 0 ? print(p.bg_black) : print(p.bg_gray)
      end
    end
    print "\n" 
  end

  def validate_play(start, finish)
    return false if start == finish
    color, enemy_color = nil
    sym = PIECE.find do |k,v|
      color = k
      break v.key(@grid[start.first][start.last]) if v.key(@grid[start.first][start.last])
    end
    color == :white ? enemy_color = "black".to_sym : enemy_color = :white
    if sym == :pawn #special case black/white
      valid_dir = TRANS[sym][:black].select { |n| (start.add(n)).between?(start, finish) }
      valid_dir = TRANS[sym][:white].select { |n| (start.add(n)).between?(start, finish) } if valid_dir.empty?
    else
      valid_dir = TRANS[sym].select { |n| (start.add(n)).between?(start, finish) }
    end
    return false if valid_dir.empty?
    if (sym == :king || sym == :knight || sym == :pawn)
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
        if point.between?(start,finish) && @grid[point.first, point.last] == EMPTY
          points[i].push(point) 
        else
          if point == finish && PIECE[enemy_color].has_value?(@grid[finish.first, finish.last]) 
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

  def check_mate?
    return false unless check?    
  end

  def check?
    false
  end
end

board = Board.new
board.draw
p board.validate_play([0,0], [0,1])
