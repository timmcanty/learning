require_relative 'card.rb'

class Deck

  def initialize(full=false)
    @cards = ( full ? Card.all_cards : [] )
    shuffle
  end

  def count
    @cards.count
  end

  def take(num = 1)
    @cards.shift(num)
  end

  def add(cards)
    cards.each { |card| @cards << card }
  end

  private

  def shuffle
    @cards.shuffle!
  end
end
