require 'spec_helper'

describe Stock do

  it { should belong_to(:user) }

  it { should_not allow_mass_assignment_of(:user_id) }

  [:symbol, :shares, :price].each do |attribute|
    it { should validate_presence_of(attribute) }
    it { should allow_mass_assignment_of(attribute) }
  end

  [10, 10.1234, '10', '10.1234', 0, '0'].each do |val|
    it { should allow_value(val).for(:price) }
    it { should allow_value(val).for(:shares) }
  end

  ['NaN', nil, '', '   '].each do |val|
    it { should_not allow_value(val).for(:price) }
    it { should_not allow_value(val).for(:shares) }
  end

end
