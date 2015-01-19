class Hand

  HAND_TYPES = {
    :high_card => 1, #highest card
    :one_pair => 2,  #highest double
    :two_pair => 3,  #highest double
    :three_of_a_kind => 4, #highest triplet
    :straight => 5, #highest card
    :flush => 6, #highest card
    :full_house => 7, #highest triplet THEN highest double
    :four_of_a_kind => 8, #highest triplet
    :straight_flush => 9 #highest card
  }

  def self.poker_hand(deck)
    Hand.new(deck.take(5))
  end

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def count
    @cards.count
  end

  def draw(deck, num)
    raise "you can only hold five cards" if count + num > 5
    @cards.concat(deck.take(num))
  end

  def return(deck,indices)
    raise "invalid index" unless indices.all? { |el| el.between?(0,4) }
    rejected_cards = []
    cards.each_index do |i|
      rejected_cards << cards[i] if indices.include?(i)
    end

    rejected_cards.each do |card|
      cards.delete(card)
    end

    deck.add(rejected_cards)
  end

  def highest_rank
    highest_card = @cards.max_by { |card| card.poker_value }
    highest_card.rank
  end

  def straight
    values = @cards.map { |card| card.poker_value }
    values.sort!
    return nil unless values.last - values.first == 4 && values == values.uniq

    self.highest_rank
  end

  def flush
    suits = @cards.map { |card| card.suit }
    return nil if suits.uniq.count > 1

    self.highest_rank
  end

  def doubles
    counter = Hash.new(0)

    cards.each do |card|
      counter[card.rank] += 1
    end

    pairs = counter.select { |ranks,freq| freq == 2}.keys
    return (pairs.empty? ? nil : pairs)
  end

  def triples
    counter = Hash.new(0)

    cards.each do |card|
      counter[card.rank] += 1
    end

    pairs = counter.select { |ranks,freq| freq == 3}.keys
    return (pairs.empty? ? nil : pairs[0])
  end

  def quadruples
    counter = Hash.new(0)

    cards.each do |card|
      counter[card.rank] += 1
    end

    pairs = counter.select { |ranks,freq| freq == 4}.keys
    return (pairs.empty? ? nil : pairs[0])
  end

  def hand_type
    raise "Poker hands need five cards!" if count != 5
    return :straight_flush if straight && flush
    return :four_of_a_kind if quadruples
    return :full_house if triples && doubles
    return :flush if flush
    return :straight if straight
    return :three_of_a_kind if triples
    return :two_pair if doubles.size == 2
    return :one_pair if doubles
    return :high_card
  end

  def self.<=>(hand1,hand2)
    if hand1.hand_type != hand2.hand_type
      return HAND_TYPES[hand1.hand_type] <=> HAND_TYPES[hand2.hand_type]
    end

    highest_card_types = [:high_card,:straight,:flush,:straight_flush]

    if highest_card_types.include(hand1.hand_type)
      hand1.highest_card.poker_value <=> hand2.highest_card.poker_value
    elsif hand1.hand_type == :one_pair

      hand1_value = hand1.doubles.map { |rank| Card.poker_value(rank)}.max
      hand2_value = hand2.doubles.map { |rank| Card.poker_value(rank)}.max
      hand1_value <=> hand2_value
    elsif hand1.hand_type == :two_pair

      hand1_values = hand1.doubles.map { |rank| Card.poker_value(rank)}.sort
      hand2_values = hand2.doubles.map { |rank| Card.poker_value(rank)}.sort
      return hand1_values[1] <=> hand2_values[1] unless hand1_values <=> hand2_values == 0
      hand1_values[0] <=> hand_values[0]

    elsif hand1.hand_type == :triples
      hand1_value = Card.poker_value(hand1.triples)
      hand2_value = Card.poker_value(hand1.triples)
      hand1_value <=> hand2_value

    elsif hand1.hand_type ==

  end

# HAND_TYPES = {
#   :high_card => 1, #highest card
#   :one_pair => 2,  #highest double
#   :two_pair => 3,  #highest double THEN next HIGHEST pair
#   :three_of_a_kind => 4, #highest triplet
#   :straight => 5, #highest card
#   :flush => 6, #highest card
#   :full_house => 7, #highest triplet THEN highest double
#   :four_of_a_kind => 8, #highest quadruple
#   :straight_flush => 9 #highest card
# }


end
