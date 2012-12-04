require 'ostruct'

class OpenStruct
  
  def merge!(hash)
    marshal_dump.merge!(hash).to_ostruct
  end
  
end