require 'spec_helper'

describe "HashtiveRecord" do

  before(:all) do
    
    @players = build(:table, id: :players)
    @races = build(:table, id: :races)
    @matches = build(:table, id: :matches)

    @lineker_rec = build(:record, hash: {lineker: {event_id: :footie_match, event_type: :match }})
    @christie_rec = build(:record, hash: {christie: {event_id: :running_race, event_type: :race }})
    @arsenal_rec = build(:record, hash: {footie_match: {stadium: "Arsenal"} } )
    @olympic_rec = build(:record, hash: {running_race: {stadium: "Olympic"} } )
    @players << @lineker_rec
    @players << @christie_rec
    @races << @arsenal_rec
    @matches << @olympic_rec
    
    @database = build(:database)
    @database.tables << @players << @races << @matches
    HashtiveRecord::Base.database = @database
    
    module Event
      extend ActiveSupport::Concern
      included { has_many :players, as: :event }
    end
    
    class Player < HashtiveRecord::Base
      belongs_to :event, polymorphic: true
    end
    
    class Race < HashtiveRecord::Base
      include Event
    end
    
    class Match < HashtiveRecord::Base
      include Event
    end
  end
  
  
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