require 'card.rb'

describe Card do

  context '#initialize' do

    it "creates a valid card" do
      card = Card.new(:spade,:seven)
      expect(card).to be_a(Card)
      expect(card.suit).to eq(:spade)
      expect(card.rank).to eq(:seven)
    end

    it "rejects an invalid card" do
      expect { Card.new(:seven, :spade) }.to raise_error("invalid card")
    end
  end

  context '#==' do
    let(:card1) { Card.new(:spade, :king) }
    let(:dup_card) { Card.new(card1.suit, card1.rank) }
    let(:card2)  { Card.new(:diamond, :three) }

    it "matches identical cards" do
      expect(card1).to eq(dup_card)
    end

    it "detects different cards" do
      expect(card1).not_to eq(card2)
    end
  end

  context '#to_s' do
    let(:card) { Card.new(:heart, :eight) }

    it "displays card information" do
      expect(card.to_s).to eq("8♥")
    end
  end

  context '#poker_value' do
    let(:card) { Card.new(:heart, :eight) }

    it "returns poker value properly" do
      expect(card.poker_value).to eq(6)
    end
  end

  context '#all_cards' do
    let(:cards) { Card.all_cards }

    it "gets a full set of cards" do
      expect(cards.count).to eq(52)
    end
  end
end
