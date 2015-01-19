# encoding: utf-8
require_relative 'checkers_piece.rb'
require_relative 'checkers_board.rb'

class Checkers

  def initialize(player_red,player_black)
    @board = Board.new(true)
    @red, @red.color = player_red, :r
    @black, @black.color = player_black, :b
  end

  def run
    turn = [@red,@black]

    until over?
      begin
        @board.render
        can_slide = @board.can_slide?(turn.first.color)
        puts "You must jump!" unless can_slide
        sequence = turn.first.get_sequence

        raise InvalidInputError unless sequence.any? { |move| move.is_a?(Array) && move.size == 2 }

        start_pos = sequence.shift


        raise NotYoursError if @board[start_pos].nil? || turn.first.color != @board[start_pos].color

        @board[start_pos].perform_moves(sequence,can_slide)

        turn.rotate!


      rescue CheckersError => e
        puts e.message
        retry
      end
    end

    if winner == :r
      puts "Red is the winner!"
    else
      puts "Black is the winner!"
    end

  end

  def over?
    @board.pieces.select { |piece| piece.color == :r}.empty? ||
    @board.pieces.select { |piece| piece.color == :b}.empty?
  end

  def winner
    @board.pieces.sample.color
  end


end

class Player

  attr_accessor :color

  def get_sequence
  end


end

class HumanPlayer < Player

  def get_sequence
    print ( color == :r ? "Red: " : "Black: ")
    puts "Enter your piece location then move sequence!"
    puts "(ex. 1,1 3,3 5,5 7,7 for 3 jumps)"
    input = gets.chomp

    moves = input.split(' ')

    moves.map { |move| move.split(',').map { |chr| chr.to_i + -1 } }

  end

end


class NotYoursError < CheckersError
end


if __FILE__ == $PROGRAM_NAME
  Checkers.new(HumanPlayer.new,HumanPlayer.new).run
end
