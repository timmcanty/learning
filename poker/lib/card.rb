class Card
  SUITS = {
    :club    => "♣",
    :diamond => "♦",
    :heart   => "♥",
    :spade   => "♠"
  }

  RANKS = {
    :deuce => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
  }

  POKER_VALUE = {
    :deuce => 0,
    :three => 1,
    :four  => 2,
    :five  => 3,
    :six   => 4,
    :seven => 5,
    :eight => 6,
    :nine  => 7,
    :ten   => 8,
    :jack  => 9,
    :queen => 10,
    :king  => 11,
    :ace   => 12
  }

  attr_reader :suit, :rank

  def initialize(suit, rank)
    raise "invalid card" unless SUITS.include?(suit) && RANKS.include?(rank)

    @suit = suit
    @rank = rank
  end

  def ==(other_card)
    suit == other_card.suit && rank == other_card.rank
  end

  def to_s
    RANKS[rank] + SUITS[suit]
  end

  def poker_value
    POKER_VALUE[rank]
  end

  def self.poker_value(rank)
    POKER_VALUE[rank]
  end

  def self.all_cards
    cards = []
    SUITS.keys.each do |suit|
      RANKS.keys.each do |rank|
        cards << Card.new(suit,rank)
      end
    end

    cards
  end

end
