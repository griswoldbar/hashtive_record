class Symbol
  def eqify
    (to_s + "=").to_sym
  end
  
  def to_class
    to_s.singularize.classify.constantize
  end
end