require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Types::QueryTypes::SourceQueryType do
  ctx       = {}
  variables = {}

  let(:result) do
    WordsSchema.execute(
      query_string,
      context: ctx,
      variables: variables
    )
  end

  describe 'words query' do
    words = [
      { 'word' => '私', 'count' => 1 },
      { 'word' => '北海道', 'count' => 2 },
      { 'word' => '旭川', 'count' => 3 }
    ]

    let(:query_string) do
      <<~QUERY
        {
          words(fullPath: "#{source.full_path}") {
            word
            count
          }
        }
      QUERY
    end

    context 'Source does not exist' do
      let(:source) { build(:source) }

      it 'retruns errors' do
        assert_match("Couldn't find Source", result['errors'][0]['message'])
      end
    end

    context 'when Source exists' do
      before do
        create(:noun, source: source, word: words[0]['word'], count: words[0]['count'])
        create(:noun, source: source, word: words[1]['word'], count: words[1]['count'])
        create(:noun, source: source, word: words[2]['word'], count: words[2]['count'])
      end

      let(:source) { create(:source) }

      it 'returns key ["words"] as Array' do
        assert_instance_of(Array, result['data']['words'])
      end

      it 'returns key ["words"] with length of 3' do
        assert_equal(3, result['data']['words'].length)
      end

      it 'returns ["words"][n]["word"] as String' do
        3.times do |n|
          assert_instance_of(String, result['data']['words'][n]['word'])
        end
      end

      it 'returns ["words"][n]["word"] with values' do
        result_words = result['data']['words'].map { |noun| noun['word'] }

        assert_includes(result_words, words[0]['word'])
        assert_includes(result_words, words[1]['word'])
        assert_includes(result_words, words[2]['word'])
      end

      it 'returns ["words"][n]["count"] as Integer' do
        3.times do |n|
          assert_instance_of(Integer, result['data']['words'][n]['count'])
        end
      end

      context 'with query args such as "order" and "limit"' do
        let(:limit) { 2 }
        let(:query_string) do
          <<~QUERY
            {
              words(fullPath: "#{source.full_path}", order: "#{order}", limit: #{limit}) {
                word
                count
              }
            }
          QUERY
        end

        context 'when "order" is "desc"' do
          let(:order) { 'desc' }

          it 'returns key ["words"] with length of 2' do
            assert_equal(2, result['data']['words'].length)
          end

          it 'returns "desc" sorted words' do
            assert_equal(words[2], result['data']['words'].first)
            assert_equal(words[1], result['data']['words'].last)
          end
        end

        context 'when "order" is "asc"' do
          let(:order) { 'asc' }

          it 'returns key ["words"] with length of 2' do
            assert_equal(2, result['data']['words'].length)
          end

          it 'returns "asc" sorted words' do
            assert_equal(words[0], result['data']['words'].first)
            assert_equal(words[1], result['data']['words'].last)
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
