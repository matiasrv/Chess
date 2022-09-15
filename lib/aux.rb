require "yaml"
require "fileutils"
class String  
  def black;          "\e[30m#{self}\e[0m" end
  def white;          "\e[38m#{self}\e[0m" end

  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
end

class Array
  def add(b)
    [self.first + b.first, self.last + b.last]
  end
  def between?(a,b)
    (self.first.between?(a.first,b.first) || self.first.between?(b.first,a.first)) &&
    (self.last.between?(a.last,b.last) || self.last.between?(b.last,a.last))
  end
end
WHITE = :white
BLACK = :black
EMPTY = ' '
PIECE = {
  white: { king: "\u265A".white, queen: "\u265B".white, rook: "\u265C".white, bishop: "\u265D".white, knight: "\u265E".white, pawn: "\u265F".white }.freeze,
  black: { king: "\u265A".black, queen: "\u265B".black, rook: "\u265C".black, bishop: "\u265D".black, knight: "\u265E".black, pawn: "\u265F".black }.freeze
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
IDX = {
  row: {a: 0, b: 1, c: 2, d:3 ,e: 4, f: 5, g: 6, h:7},
  column: {:"1" => 0,:"2" => 1,:"3" => 2,:"4" => 3,:"5" => 4,:"6" => 5,:"7" => 6,:"8" => 7}
}
SAVE_LOCATION = "saves"
FNAME = "saves/save.txt"
def save_game(grid, current_player)
  Dir.mkdir(SAVE_LOCATION) unless Dir.exist?(SAVE_LOCATION)
  content = YAML.dump({ grid: grid , player: current_player})
  File.open(FNAME,"w") { |file| file.puts content }
  puts "Game saved"
end

def delete_save
  if Dir.exist?(SAVE_LOCATION)
    FileUtils.remove_dir(SAVE_LOCATION) 
    puts "Save deleted"
  else
    puts "Nothing to delete!"  
  end
end

def load_game
  content = YAML.load (File.read(FNAME)) if File.exist?(FNAME)
end