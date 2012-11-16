class Symbol
  def eqify
    (to_s + "=").to_sym
  end
  
  def idify
    (to_s + "_id").to_sym
  end
  
  def to_class
    to_s.singularize.classify.constantize
  end
  
  def singularize
    to_s.singularize.to_sym
  end
end