require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:event_date) }
  end

  describe '#associations' do
    it { should have_many :presentations }
  end
end
