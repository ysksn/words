require 'rails_helper'

RSpec.describe Source, type: :model do
  let(:source) { build(:source, trait) }

  describe '#crawled' do
    let(:trait) { :has_not_crawled }

    it 'updates @crawled_at' do
      refute source.crawled_at

      travel_to = Time.zone.local(2018, 9, 29, 15, 12, 1)

      travel_to travel_to do
        source.crawled
        assert_equal travel_to, source.crawled_at
      end
    end
  end

  describe '#crawlable?' do
    subject { source.crawlable? }

    context '@crawled_at in nil' do
      let(:trait) { :has_not_crawled }

      it 'returns true' do
        assert subject
      end
    end

    context '@crawled_at is more than Source::MINIMUM_CRAWLABLE_BETWEEN minutes ago' do
      let(:trait) { :has_crawled_long_time_go }

      it 'returns true' do
        assert subject
      end
    end

    context '@crawled_at is less than Source::MINIMUM_CRAWLABLE_BETWEEN minutes ago' do
      let(:trait) { :has_crawled_recentry }

      it 'returns false' do
        refute subject
      end
    end
  end
end
