require 'open-uri'
require 'to_nouns'

module Factories
  class NounFactory
    # rubocop:disable Metrics/MethodLength
    def initialize(source:)
      @source = source
      @uri    = URI(source.full_path)
      @host   = Host.find_or_initialize_by(name: @uri.host)

      @source.attributes = {
        scheme:    @uri.scheme,
        path:      @uri.path,
        query:     @uri.query,
        fragment:  @uri.fragment,
        full_path: @uri.to_s,
        host:      @host
      }
    end

    using ToNouns

    def register_nouns
      paragraphs = retriave_paragraphs
      str        = paragraphs_to_s(paragraphs: paragraphs)
      nouns      = str.to_nouns
      hash       = generate_noun_with_count(nouns: nouns)

      Noun.transaction do
        @source.nouns.delete_all

        hash.each do |word, count|
          @source.nouns.build(word: word, count: count)
        end

        @source.crawled
        @host.save!
        @source.save!
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def retriave_paragraphs
      doc = Nokogiri::HTML(URI.open(URI(@source.full_path)))
      doc.css('p')
    end

    def paragraphs_to_s(paragraphs:)
      paragraphs.map(&:content).join.gsub(/[[:ascii:]]/, '')
      # paragraphs.inject('') do |memo, sentence|
      #   memo + sentence.content
      # end.gsub(/[[:ascii:]]/, '')
    end

    def generate_noun_with_count(nouns:)
      nouns.each_with_object({}) do |noun, hash|
        hash[noun].nil? ? hash[noun] = 1 : hash[noun] += 1
      end
    end
  end
end
