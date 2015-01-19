require 'hand.rb'

describe Hand do

  context "#count" do

    it "counts the number of cards in hand" do
      cards = Hand.new([1,2])
      expect(cards.count).to eq(2)
    end


  end

  context "Hand::poker_hand" do

    let(:deck) { double("deck", :deck_cards => [Card.new(:spade,:four),
      Card.new(:heart,:deuce),
      Card.new(:diamond,:three),
      Card.new(:club,:five),
      Card.new(:spade,:six)] ) }

    it "makes a five card hand" do
      expect(deck).to receive(:take).with(5).and_return(deck.deck_cards)

      expect(Hand.poker_hand(deck).count).to eq(5)
    end

  end

  context "#draw" do
    let(:deck) { double("deck", :deck_cards => [Card.new(:diamond,:four), Card.new(:heart,:seven) ] ) }
    subject(:hand) { Hand.new( [Card.new(:heart, :deuce), Card.new(:diamond, :three) ] ) }

    it "draws cards from deck" do
      expect(deck).to receive(:take).with(2).and_return(deck.deck_cards)

      hand.draw(deck, 2)
    end

    it "adds cards to hand" do
      expect(deck).to receive(:take).with(2).and_return(deck.deck_cards)

      hand.draw(deck, 2)

      expect(hand.count).to eq(4)
    end

    it "doesn't allow more than five cards in hand" do
      expect(deck).to receive(:take).with(2).and_return(deck.deck_cards)

      hand.draw(deck, 2)

      expect { hand.draw(deck,2) }.to raise_error("you can only hold five cards")
    end
  end

  context "#return" do
    let(:deck) { double("deck") }
    subject(:hand) { Hand.new( [Card.new(:heart, :deuce), Card.new(:diamond, :three) ] ) }

    it "removes card at given index" do
      expect(deck).to receive(:add)
      hand.return(deck,[0])
      expect(hand.cards).to eq([Card.new(:diamond,:three)])
    end

    it "returns cards to deck" do
      expect(deck).to receive(:add)

      hand.return(deck,[0,1])
    end

    it "removes cards from hands" do
      expect(deck).to receive(:add)
      hand.return(deck,[0,1])

      expect(hand.count).to eq(0)
    end

    it "handles improper indices" do
      expect{ hand.return(deck,[6])}.to raise_error("invalid index")
    end
  end

  context "#highest_rank" do
    subject(:hand) { Hand.new( [Card.new(:heart, :four), Card.new(:diamond, :three) ] ) }

    it "chooses highest ranked card in hand" do
      expect(hand.highest_rank).to eq(:four)
    end

  end

  context "#straight" do
    subject(:straight_hand) { Hand.new( [Card.new(:spade,:four),
        Card.new(:heart,:deuce),
        Card.new(:diamond,:three),
        Card.new(:club,:five),
        Card.new(:spade,:six)] )  }

    it "detects a straight" do
      expect(straight_hand.straight).to eq(:six)
    end
  end

  context "#flush" do
    subject(:flush_hand) { Hand.new( [Card.new(:spade,:four),
        Card.new(:spade,:deuce),
        Card.new(:spade,:three),
        Card.new(:spade,:five),
        Card.new(:spade,:six)] )  }

    it "detects a flush" do
      expect(flush_hand.flush).to eq(:six)
    end
  end

  context "#doubles" do    #  2,2,3,3,7   ([2,3])
    let(:triple_hand) { Hand.new( [Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:jack),
        Card.new(:spade,:six)] )  }

    let(:deuce_pairs) { Hand.new(  [Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:jack),
        Card.new(:spade,:jack),
        Card.new(:spade,:six)] )  }

    it "does not detect triples or quadruples" do
      expect(triple_hand.doubles).to be_falsy
    end

    it "detects two pairs" do
      expect(deuce_pairs.doubles).to eq([:four,:jack])
    end
  end

  context "#triples" do
    let(:triple_hand) { Hand.new(  [Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:jack),
        Card.new(:spade,:six)] )  }

    let(:quads_hand) { Hand.new(  [Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:six)] )  }

    it "does not detect quadruples" do
      expect(quads_hand.triples).to be_falsy
    end

    it "detects triples" do
      expect(triple_hand.triples).to eq(:four)
    end
  end

  context "#quadruples" do
    let(:quads_hand) { Hand.new(  [Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:four),
        Card.new(:spade,:six)] )  }

    it "detects quadruples" do
      expect(quads_hand.quadruples).to eq(:four)
    end
  end

  context "#hand_type" do

    it "requires a hand of 5 cards" do
      hand = Hand.new([])

      expect { hand.hand_type}.to raise_error("Poker hands need five cards!")
    end
  end



  context "Hand::<=>" do
    it "distinguishes between different hand types" do
      let(:hand1) { double("hand", :hand_type => :flush) }
      let(:hand2) { double("hand", :hand_type => :straight) }

      expect(hand1 <=> hand2).to eq(-1)
    end

    it "distinguishes between equal hand types" do
      let(:hand1) { double("hand", :hand_type => :deuce_pair, :doubles => [:four, :six] ) }
      let(:hand2) { double("hand", :hand_type => :deuce_pair, :doubles => [:three, :four] ) }

      expect(hand1 <=> hand2).to eq(-1)
    end

    it "detects equal hands" do
      let(:hand1) { double("hand", :flush => :eight  ) }
      let(:hand2) { double("hand", :flush => :eight ) }

      expect(hand1 <=> hand2).to eq(0)
    end

  end

end


# compare two hands
