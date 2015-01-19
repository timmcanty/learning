# encoding: utf-8

class Board
  require 'colorize'

  def initialize(setup = false)
    @board = Array.new(8) { Array.new(8) }
    place_pieces if setup
  end

  def [](pos)
    @board[ pos[0] ][ pos[1] ]
  end

  def []=(pos, piece)
    @board[ pos[0]][ pos[1]] = piece
  end

  def is_valid?(pos)
    pos.all? { |coord| coord.between?(0,7) } && ( pos[0] + pos[1]).even?
  end

  def pieces
    @board.flatten.compact
  end

  def dup
    dup_board = Board.new

    pieces.each do |piece|
      Piece.new(piece.color,dup_board, piece.pos, piece.king)
    end

    dup_board
  end

  def render
    puts "--+---+---+---+---+---+---+---+---+"
    7.downto(0).each do |row|
      print "#{row+1} |"
      (0..7).each do |col|
        if (row+col).even?
          print " "
          print (self[[col,row]] ? self[[col,row]].char : " " )
          print " |"
        else
          print "   ".colorize( :background => :black)
          print "|"
        end
      end
      puts
      puts "--+---+---+---+---+---+---+---+---+"
    end
    puts "# | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |"
  end

  # print "#{row+1} | "
  # (0..7).each do |col|
  #   print (self[[col,row]] ? self[[col,row]].char : " " )
  #   print " | "
  # end

  def can_slide?(color)
    your_pieces = pieces.select { |piece| piece.color == color}

    your_pieces.all? do |piece|
      piece.jumps.empty?
    end

  end

  private

  def place_pieces
    [0,1,2,5,6,7].each do |row|
      color = ( row < 3 ? :r : :b)
      (0..7).each do |col|
        self[[col,row]] = Piece.new( color, self, [col,row] ) if self.is_valid?([col,row])
      end
    end
  end
end
