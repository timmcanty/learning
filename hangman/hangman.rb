class HangMan
  GUESS_LIMIT = 8

  def initialize(referee,guesser)
    @word = (referee.get_word).chars
    @state = @word.map { nil }
    @player = guesser
    @guesses = 0
  end

  attr_reader :player, :state, :word

  def render
    printed_string = ""
    @state.each do |el|
      if el.nil?
        printed_string << "_"
      else
        printed_string << el
      end
    end
    puts "Secret word: #{printed_string}"
    puts "Mistakes Remaining: #{GUESS_LIMIT - @guesses}"
  end

  def run

    until over?
      render
      current_guess = get_guess
      update_state(current_guess)
    end

    if win?
      puts "YOU GOT IT!"
    else
      puts "A MAN IS DEAD BECAUSE OF YOU!"
    end

  end

  def get_guess
    @player.guess
  end

  def check_guess(guess)
    @word.include?(guess)
  end

  def update_state(guess)
    if check_guess(guess)
      @word.each_with_index do | el, i|
        @state[i] = guess if el == guess
      end
    else
      @guesses +=1
    end
  end

  def win?
    state == word
  end

  def over?
    win? || @guesses == GUESS_LIMIT
  end

end

class Player

  def get_word
  end

  def receive_length(length)
  end

  def guess
  end

end

class HumanPlayer < Player

  def get_word
    puts "Select a word"
    gets.chomp
  end

  def guess
    puts "Guess a letter!"
    selection = gets.chomp

    until selection.length == 1 && selection.match(/[[:lower:]]/)
      puts "Invalid Response: One Lowercase Letter Please!"
      selection = gets.chomp
    end

    selection
  end


end

class ComputerPLayer < Player

  def initialize
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @possibilities = @dictionary
    @guess_space = "a".upto("z").to_a
  end

  def get_word
    @dictionary.sample
  end

  def receive_length(length)
    @length = length
  end


end
