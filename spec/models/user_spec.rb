require 'spec_helper'

describe User do

  let!(:user) { create(:user) }

  it { should validate_presence_of   :email }
  it { should validate_uniqueness_of :email }

  [:email, :password, :password_confirmation, :remember_me].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

  [:encrypted_password, :reset_password_token, :reset_password_sent_at,
   :remember_created_at, :sign_in_count, :current_sign_in_at,
   :sign_in_count, :last_sign_in_at, :current_sign_in_ip,
   :last_sign_in_ip].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

  it { should have_many :stocks }

end
