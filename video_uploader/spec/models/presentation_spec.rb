require 'rails_helper'

RSpec.describe Presentation, type: :model do
  describe '#validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:presented_at) }
  end

  describe '#associations' do
    it { should belong_to :event}
    it { should belong_to :playlist}
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

  describe '#has_video_link?' do
    describe 'has video' do
      before do
        subject.video_id = 'abcd'
        subject.video_source = 'youtube'
      end

      it 'is true' do
        expect(subject).to be_has_video_link
      end
    end

    describe 'does not have video' do
      it 'is false' do
        expect(subject).to_not be_has_video_link
      end
    end
  end

  describe '#video_link' do
    describe 'youtube' do
      let(:video_id) { 'abcd' }

      before do
        subject.video_id = video_id
        subject.video_source = 'youtube'
      end

      it 'has valid URL' do
        expect(subject.video_link).to eq "https://youtu.be/#{video_id}"
      end
    end
  end
end
