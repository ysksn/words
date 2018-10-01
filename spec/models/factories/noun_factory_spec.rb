require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Factories::NounFactory do
  let(:source) { build(:source) }

  describe '.new' do
    it 'returns truthy' do
      assert described_class.new(source: source)
    end
  end

  describe '#register_nouns' do
    html_file  = Rails.root + 'spec/fixtures/hoge.html'
    doc        = Nokogiri::HTML(File.read(html_file))
    paragraphs = doc.css('p')

    let(:noun_factory) { described_class.new(source: source) }

    before do
      allow(noun_factory).to receive(:retriave_paragraphs) { paragraphs }
    end

    context 'when source does not exist yet' do
      let(:source) { build(:source) }

      it 'creates a Host' do
        expect { noun_factory.register_nouns }.to change { Host.count }.from(0).to(1)
      end

      it 'creates a Source' do
        expect { noun_factory.register_nouns }.to change { Source.count }.from(0).to(1)
      end

      it 'creates Noun(s)' do
        expect { noun_factory.register_nouns }.to change { Noun.count }.from(0).to(10)
      end
    end

    context 'when source exists' do
      let(:source) { create(:source) }

      it "doesn't create Host" do
        expect { noun_factory.register_nouns }.not_to change { Host.count }
      end

      it "doesn't create Source" do
        expect { noun_factory.register_nouns }.not_to change { Source.count }
      end

      it 'creates Noun(s)' do
        expect { noun_factory.register_nouns }.to change { Noun.count }.from(0).to(10)
      end

      it 'changes source@crawled_at' do
        travel_to = Time.zone.local(2020, 9, 29, 15, 12, 1)
        travel_to travel_to do
          expect { noun_factory.register_nouns }.to change { source.crawled_at }
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
