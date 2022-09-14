require_relative 'aux'

class Board
  def initialize
    @white_check, @black_check = false
    @king_pos = { black: [7, 4], white: [0, 4] }

    @grid = []
    @grid.push [PIECE[WHITE][:rook], PIECE[WHITE][:knight], PIECE[WHITE][:bishop], PIECE[WHITE][:queen],
                PIECE[WHITE][:king], PIECE[WHITE][:bishop], PIECE[WHITE][:knight], PIECE[WHITE][:rook]]
    @grid.push [PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn],
                PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn], PIECE[WHITE][:pawn]]
    @grid.push(Array.new(8) { EMPTY })
    @grid.push(Array.new(8) { EMPTY })
    @grid.push(Array.new(8) { EMPTY })
    @grid.push(Array.new(8) { EMPTY })
    @grid.push [PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn],
                PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn], PIECE[BLACK][:pawn]]
    @grid.push [PIECE[BLACK][:rook], PIECE[BLACK][:knight], PIECE[BLACK][:bishop], PIECE[BLACK][:queen],
                PIECE[BLACK][:king], PIECE[BLACK][:bishop], PIECE[BLACK][:knight], PIECE[BLACK][:rook]]
    @pieces = { black: all_positions(BLACK), white: all_positions(WHITE) }
  end

  def draw
    char = 'H'
    @grid.reverse.each_with_index do |row, y|
      print "\n" if y != 0
      print char, ' '
      char = (char.ord - 1).chr
      row.each_with_index do |p, x|
        (x + y).even? ? print(p.bg_cyan) : print(p.bg_brown)
      end
    end
    print "\n"
    puts '  12345678', ''
  end

  def validate_play(start, finish, player)
    return false if start == finish
    return false unless start.between?([0, 0], [7, 7]) && finish.between?([0, 0], [7, 7])

    this_color, this_piece, oposite_color = :none
    PIECE.each do |clr, hash|
      hash.each do |piece, char|
        if char == @grid[start.first][start.last]
          this_color = clr
          this_piece = piece
        end
      end
    end
    oposite_color = this_color == WHITE ? BLACK : WHITE
    return false if this_color != player

    if this_piece != :king and this_color == WHITE && @white_check || this_color == BLACK && @black_check and
       finish != @last_pos
      return puts "#{this_color.capitalize}'s king is in check"
    end
    return false unless reach(start, finish, this_piece, this_color, oposite_color)

    true
  end

  def place_piece(start, finish, player)
    s = [IDX[:row][start[0].downcase.to_sym], IDX[:column][start[1].downcase.to_sym]]
    f = [IDX[:row][finish[0].downcase.to_sym], IDX[:column][finish[1].downcase.to_sym]]
    valid = validate_play(s, f, player)
    return puts 'Invalid play' unless valid

    @last_pos = f
    @last_color = player
    @last_oposite = player == WHITE ? BLACK : WHITE
    @last_key = PIECE[@last_color].key(@grid[s.first][s.last])
    @king_pos[@last_color] = f if @last_key == :king
    if @last_key == :king || validate_play(f, @king_pos[@last_color], @last_oposite)
      @last_color == WHITE ? @white_check = false : @black_check = false
    end
    puts "#{@last_key} #{@grid[s.first][s.last]} from #{start} to #{finish} #{@grid[f.first][f.last]}", ''
    @grid[f.first][f.last] = PIECE[player][@last_key]
    @grid[s.first][s.last] = EMPTY
    @pieces[@last_color].keep_if { |pos| pos != s }
    @pieces[@last_color].push f
    @pieces[@last_oposite].keep_if { |pos| pos != f }
  end

  def count(color)
    @grid.inject(0) { |a, b| sum = a + b.count { |c| PIECE[color].has_value? c } }
  end

  def check_mate?
    return false unless check?
    return false unless @black_check || @white_check

    color, oposite = 0
    color = @black_check ? BLACK : WHITE
    oposite = color == WHITE ? BLACK : WHITE
    king_moves = king_moves_available(color, oposite)
    allies = @pieces[color]

    saved = allies.any? do |ally|
      validate_play(ally, @last_pos, color)
    end
    if king_moves.empty? and !saved
      puts "Checkmate, #{oposite.capitalize} wins"
      true
    else
      puts "#{color.capitalize} king is in check(checkmate)"
    end
  end

  def check?
    is_check = validate_play(@last_pos, @king_pos[@last_oposite], @last_color)
    if is_check
      @last_oposite == WHITE ? @white_check = true : @black_check = true
    end
    is_check
  end

  private

  def reach(start, finish, piece, color, oposite)
    return false unless start.between?([0, 0], [7, 7]) && finish.between?([0, 0], [7, 7])
    return false if PIECE[color].has_value? @grid[finish.first][finish.last]

    if piece == :pawn # special case black/white
      return false if (start[0] - finish[0]).abs > 1 and
                      (start[0] != IDX[:row][:g] && color == BLACK) ||
                      (start[0] != IDX[:row][:b] && color == WHITE)

      valid_dir = TRANS[piece][color].select { |n| start.add(n).between?(start, finish) }
      return false if (start[1] - finish[1]) != 0 && @grid[finish.first][finish.last] == EMPTY
    else
      valid_dir = TRANS[piece].select { |n| start.add(n).between?(start, finish) }
    end
    return false if valid_dir.empty?

    if %i[knight pawn].include?(piece)
      valid = valid_dir.select do |dir|
        start.add(dir) == finish and (start.last - finish.last).abs != 0 || !PIECE[oposite].has_value?(@grid[finish.first][finish.last])
      end
      return false if valid.empty?

      return true
    elsif piece == :king
      valid = valid_dir.select do |dir|
        start.add(dir) == finish
      end
      return false if valid.empty?

      @pieces[oposite].each do |enemy|
        enemy_piece = PIECE[oposite].key(@grid[enemy.first][enemy.last])
        next if enemy_piece == :king
        return false if reach(enemy, finish, enemy_piece, oposite, color)
      end
      return true
    end

    paths = []
    valid_dir.each { |d| paths.push [start.add(d)] }
    skip = []
    until paths.empty?
      return false if skip.size == paths.size || PIECE[color].has_value?(@grid[finish.first][finish.last])

      paths.each { |points| return true if points.include? finish }

      for i in (0...paths.size) do
        next if skip.include?(i)

        point = paths[i].last.add(valid_dir[i])
        if point.between?(start, finish) && @grid[point.first][point.last] == EMPTY
          paths[i].push(point)
        elsif point == finish && PIECE[oposite].has_value?(@grid[finish.first][finish.last])
          paths[i].push(point)
        else
          skip << i
        end
      end
    end
  end

  def all_positions(color)
    positions = []
    @grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        positions << [x, y] if PIECE[color].has_value?(piece)
      end
    end
    positions
  end

  def king_moves_available(color, oposite)
    start = @king_pos[color]
    TRANS[:king].filter_map do |t|
      finish = start.add(t)
      finish if reach(start, finish, :king, color, oposite)
    end
  end
end
