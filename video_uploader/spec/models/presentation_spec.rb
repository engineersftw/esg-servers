require 'rails_helper'

RSpec.describe Presentation, type: :model do
  describe '#validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:presented_at) }
  end

  describe '#needs_video?' do
    context 'will needs video' do
      before do
        subject.status = status
      end

      %w(pending failed_to_process failed_to_publish).each do |current_status|
        describe "current status is #{current_status}" do
          let(:status) { current_status }
          specify { expect(subject).to be_needs_video }
        end
      end
    end
  end
end