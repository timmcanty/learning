require 'deck.rb'

describe Deck do

  context "#count" do
    it "counts the deck" do
      deck = Deck.new(true)
      expect(deck.count).to eq(52)
    end
  end

  context "#initialize" do

    it "creates a blank deck by default" do
      deck = Deck.new
      expect(deck.count).to eq(0)
    end

    it "creates a full deck when passed true" do
      deck = Deck.new(true)
      expect(deck.count).to eq(52)
    end
  end

  context "#take" do
    subject(:deck) { Deck.new(true) }

    it "draws one card by default" do
      card = deck.take
      expect(card).to be_an(Array)
      expect(card[0]).to be_a(Card)
    end

    it "draws many cards when specified" do
      cards = deck.take(3)
      expect(cards.size).to eq(3)
    end

    it "from deck" do
      deck.take(3)
      expect(deck.count).to eq(49)
    end
  end

  context "#add" do
    subject(:deck) { Deck.new }
    let(:card) { [Card.new(:club, :four)] }
    let(:cards) { [Card.new(:spade, :seven), Card.new(:club, :four)] }

    it "adds a card" do
      deck.add(card)
      expect(deck.count).to eq(1)
    end

    it "adds multiple cards" do
      deck.add(cards)
      expect(deck.count).to eq(2)
    end

    it "to the bottom" do
      deck.add(cards)
      expect(deck.take).to eq([cards.first])
    end
  end

  context "#shuffle" do
    let(:deck1) { Deck.new(true) }
    let(:deck2) { Deck.new(true) }

    it "shuffles new decks" do
      cards1 = deck1.take(52)
      cards2 = deck2.take(52)
      expect(cards1).not_to eq(cards2)
    end
  end

end
