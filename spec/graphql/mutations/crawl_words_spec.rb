require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Mutations::CrawlWords do
  travel_to  = Time.zone.local(2019, 9, 29, 15, 12, 1)
  ctx        = {}
  html_file  = Rails.root + 'spec/fixtures/hoge.html'
  doc        = Nokogiri::HTML(File.read(html_file))
  paragraphs = doc.css('p')

  before do
    allow_any_instance_of(Factories::NounFactory).to receive(:retriave_paragraphs) do
      paragraphs
    end
  end

  let(:variables) do
    {
      input: {
        'fullPath': source.full_path
      }
    }
  end

  let(:result) do
    WordsSchema.execute(
      query_string,
      context: ctx,
      variables: variables
    )
  end

  let(:query_string) do
    <<~QUERY
      mutation crawlWords($input: CrawlWordsInput!) {
        crawlWords(input: $input) {
          source {
            fullPath
            crawledAt
          }
          errors
        }
      }
    QUERY
  end

  context "Source has't crawled recently" do
    let(:source) { create(:source, crawled_at: 100.years.ago) }

    it 'retruns Source with full_path and crawledAt' do
      travel_to travel_to do
        assert_equal(source.full_path, result['data']['crawlWords']['source']['fullPath'])
        assert_equal(travel_to,        result['data']['crawlWords']['source']['crawledAt'])
      end
    end

    it 'has no errors' do
      assert_empty result['data']['crawlWords']['errors']
    end
  end

  context 'Source has crawled recently' do
    let(:source) { create(:source, crawled_at: travel_to) }

    it 'retruns Source with full_path and crawledAt' do
      assert_equal(source.full_path, result['data']['crawlWords']['source']['fullPath'])
      assert_equal(travel_to,        result['data']['crawlWords']['source']['crawledAt'])
    end

    it 'has errors' do
      assert_match(
        'Crawled at :Please wait at least 30 minutes from the last crawl.',
        result['data']['crawlWords']['errors'][0]
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
