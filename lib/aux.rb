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

class Array
  def add(b)
    result = [self, b]
    result.transpose.map { |a| a.sum }
  end
  def between?(a,b)
    (self.first.between?(a.first,b.first) || self.first.between?(b.first,a.first)) &&
    (self.last.between?(a.last,b.last) || self.last.between?(b.last,a.last))
  end
end
EMPTY = ' '
PIECE = {
  white: { king: "\u265A".cyan, queen: "\u265B".cyan, rook: "\u265C".cyan, bishop: "\u265D".cyan, knight: "\u265E".cyan, pawn: "\u265F".cyan }.freeze,
  black: { king: "\u265A".magenta, queen: "\u265B".magenta, rook: "\u265C".magenta, bishop: "\u265D".magenta, knight: "\u265E".magenta, pawn: "\u265F".magenta }.freeze
}.freeze
TRANS = {
  king: [[0,1],[0,-1],[1,0],[-1,0],[1,1],[-1,-1],[1,-1],[-1,1]].freeze,
  queen: [[0,1],[0,-1],[1,0],[-1,0],[1,1],[-1,-1],[1,-1],[-1,1]].freeze,
  rook: [[0,1],[0,-1],[1,0],[-1,0]].freeze,
  knight: [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[-1,2],[1,-2],[-1,-2]].freeze,
  bishop: [[1,1],[-1,-1],[1,-1],[-1,1]].freeze,
  pawn: { white: [[1,0], [2,0], [1,1], [1,-1]],
          black: [[-1,0], [-2,0], [-1,1], [-1,-1]]}.freeze,
}.freeze