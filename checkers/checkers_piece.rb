# encoding: utf-8

class Piece
  require 'colorize'

  def initialize( color, board, pos, king = false)
    @color, @board, @pos, @king = color, board, pos, king

    @board[pos] = self
  end

  attr_reader :color, :board, :king, :pos

  def pos=(new_pos)
    @board[pos] = nil
    @pos = new_pos
    @board[new_pos] = self
  end

  def perform_moves!(move_sequence)
    if move_sequence.size == 1 && slides.include?(move_sequence.first)
      perform_slide(move_sequence.first)
      return
    end

    move_sequence.each do |jump|
      perform_jump(jump)
    end

    nil
  end

  def perform_moves(move_sequence, can_slide = true)
    check_forced_jump(move_sequence, can_slide)
    raise InvalidSequenceError unless valid_move_seq?(move_sequence)
    perform_moves!(move_sequence)
  end

  def valid_move_seq?(move_sequence)
    if move_sequence.size == 1 && slides.include?(move_sequence[0])
      return true
    end

    dup_board = board.dup
    dup_piece = dup_board[pos]

    move_sequence.each do |next_pos|
      dup_piece.perform_jump(next_pos)
    end

    dup_piece.jumps.empty?
  end

  def char
    return "⚈".colorize(:red) if color == :r && !king
    return "♚".colorize(:red) if color == :r && king
    return "⚈" if color == :b && !king
    return "♚" if color == :b && king
  end




  def slides
    poss_slides = move_dirs.map { |dir| add( pos, dir)}
    slides = poss_slides.select { |to_pos| valid_and_empty?(to_pos) }

    slides
  end

  def perform_slide(to_pos)
    raise InvalidMoveError unless slides.include?(to_pos)
    perform_slide!(to_pos)
  end

  def perform_slide!(to_pos)
    raise InvalidMoveError unless board.is_valid?(to_pos)

    self.pos = to_pos
    maybe_promote
  end

  def jumps
    poss_jumps = move_dirs.map { |dir| add( pos,dir, 2)}
    adjacents = move_dirs.map { |dir| add( pos, dir) }

    jumps = poss_jumps.select.each_with_index do |pos, i|
      next unless board.is_valid?(pos) && board[adjacents[i]]
      jumpable?(pos,adjacents[i])
    end

    jumps
  end

  def perform_jump(to_pos)
    raise InvalidMoveError unless jumps.include?(to_pos)
    perform_jump!(to_pos)
  end

  def perform_jump!(to_pos)
    middle = between(pos,to_pos)

    self.pos = to_pos
    maybe_promote
    board[middle] = nil
  end



  private

  def maybe_promote
    @king = true if (@color == :r ? @pos[1] == 7 : @pos[1] == 0 )
  end

  def add(vec1,vec2,times=1)
    [ (vec1[0] + times * vec2[0] ) , (vec1[1] + times * vec2[1] )]
  end

  def move_dirs
    return (@color == :r ? [ [-1, 1], [1,1] ] : [ [-1, -1], [1, -1] ] ) unless @king

    [-1,1].product([-1,1])
  end

  def between(vec1,vec2)
    [ (vec1[0] + vec2[0])/ 2 , (vec1[1] + vec2[1]) / 2]
  end

  def check_forced_jump(move_sequence, can_slide)
    raise YouMustJumpError if ( !can_slide && slides.include?(move_sequence[0] ) )
  end

  def valid_and_empty?(to_pos)
    board.is_valid?(to_pos) && !board[to_pos]
  end

  def jumpable?(to_pos,adj_pos)
    valid_and_empty?(to_pos) && (color != board[adj_pos].color)
  end

end

class CheckersError < StandardError
end

class InvalidSequenceError < CheckersError
end

class InvalidMoveError < CheckersError
end

class YouMustJumpError < CheckersError
end

class InvalidInputError < CheckersError
end
