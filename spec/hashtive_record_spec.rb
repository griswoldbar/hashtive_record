require 'spec_helper'

describe "HashtiveRecord" do

  before(:all) do
    
    @players = build(:table, id: :players)
    @races = build(:table, id: :races)
    @matches = build(:table, id: :matches)
    @dorks = build(:table, id: :dorks)
    
    @lineker_rec = build(:record, hash: {lineker: {event_id: :footie_match, event_type: :match }})
    @christie_rec = build(:record, hash: {christie: {event_id: :running_race, event_type: :race }})
    @arsenal_rec = build(:record, hash: {footie_match: {stadium: "Arsenal"} } )
    @olympic_rec = build(:record, hash: {running_race: {stadium: "Olympic"} } )
    @plonker_rec = build(:record, hash: {plonker: {name: 'Winky'}})
    @wanky_rec = build(:record, hash: {wanky: {name: 'Dorkus'}})
    
    @players << @lineker_rec << @christie_rec
    @races << @arsenal_rec
    @matches << @olympic_rec
    @dorks << @plonker_rec << @wanky_rec
    
    @database = build(:database)
    @database.tables << @players << @races << @matches << @dorks
    HashtiveRecord::Base.database = @database
    
    module Event
      extend ActiveSupport::Concern
      included { has_many :players, foreign_key: :event_id }
    end
    
    module Serf;end
    module Eunuch;end
    class Dork < HashtiveRecord::Base
      # include Serf
      # include Eunuch
      belongs_to :master, class_name: :player 
      belongs_to :overlord, class_name: :player
    end
    
    class Player < HashtiveRecord::Base
      belongs_to :event, polymorphic: true
      has_many :serfs, class_name: :dork, foreign_key: :master_id
      has_many :eunuchs, class_name: :dork, foreign_key: :overlord_id
    end
    
    class Race < HashtiveRecord::Base
      include Event
    end
    
    class Match < HashtiveRecord::Base
      include Event
    end
  end
  
  describe "polymorphics" do
    before(:each) do
      @lineker = Player.instantiate(@lineker_rec)
      @christie = Player.instantiate(@christie_rec)
      @arsenal = Match.instantiate(@arsenal_rec)
      @olympic = Race.instantiate(@olympic_rec)
    end

    it "works" do
      @arsenal.players.map(&:record).should =~ [@lineker_rec]
      @arsenal.players << @christie
      @arsenal.players.map(&:record).should =~ [@lineker_rec, @christie_rec]
      @lineker.event = @olympic
      @arsenal.players.map(&:record).should =~ [@christie_rec]
      @olympic.players.map(&:record).should =~ [@lineker_rec]
    end
  end

  describe "multi relationships" do
    before(:each) do
      @lineker = Player.instantiate(@lineker_rec)
      @christie = Player.instantiate(@christie_rec)
      @wanky = Dork.instantiate(@wanky_rec)
      @plonker = Dork.instantiate(@plonker_rec)
    end
    
    it "works" do
      @wanky.master = @lineker
      @plonker.master = @lineker
      @lineker.serfs.map(&:id).should =~ [:wanky,:plonker]
      @christie.eunuchs << @wanky
      @christie.serfs << @wanky
      @wanky.overlord.id.should == :christie
      @wanky.master.id.should == :christie
      @lineker.serfs.map(&:id).should =~ [:plonker]
      
    end
  end

  
end