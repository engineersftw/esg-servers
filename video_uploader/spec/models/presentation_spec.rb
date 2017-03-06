require 'rails_helper'

RSpec.describe Presentation, type: :model do
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