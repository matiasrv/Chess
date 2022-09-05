class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  
  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
end
  

class Board
  attr_accessor :grid
  PIECE = {
    white: { king: "\u265A".cyan, queen: "\u265B".cyan, rook: "\u265C".cyan, bishop: "\u265D".cyan, knight: "\u265E".cyan, pawn: "\u265F".cyan },
    black: { king: "\u265A".magenta, queen: "\u265B".magenta, rook: "\u265C".magenta, bishop: "\u265D".magenta, knight: "\u265E".magenta, pawn: "\u265F".magenta }
  }
  def initialize
    @grid = []
    @grid.push [ PIECE[:black][:rook], PIECE[:black][:knight], PIECE[:black][:bishop], PIECE[:black][:queen], PIECE[:black][:king], PIECE[:black][:bishop], PIECE[:black][:knight] ,PIECE[:black][:rook]] 
    @grid.push [ PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn], PIECE[:black][:pawn] ]
    @grid.push ( Array.new(8) { ' ' } )
    @grid.push ( Array.new(8) { ' ' } )
    @grid.push ( Array.new(8) { ' ' } )
    @grid.push ( Array.new(8) { ' ' } )
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

  def check_mate?
    return false unless check?    
  end

  def check?
    false
  end
end

board = Board.new
board.draw
