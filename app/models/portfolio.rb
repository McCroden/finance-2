class Portfolio < SimpleDelegator

  [:original_value, :current_value, :roi].each do |attribute|
    define_method(attribute) { sum_on(attribute) }
  end


  private

  def sum_on(attribute)
    __getobj__.sum(&attribute)
  rescue TypeError, NoMethodError
    # the values might be nil
    nil
  end
end
