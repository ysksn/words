class Mutations::CrawlWords < Mutations::BaseMutation
  argument :full_path, String, required: true

  field :source, Types::SourceType, null: true
  field :errors, [String],          null: false

  # rubocop:disable Metrics/MethodLength
  def resolve(full_path:)
    source = Source.find_or_initialize_by(full_path: full_path)

    unless source.crawlable?
      source.errors.add(:crawled_at, ":Please wait at least #{::Source::MINIMUM_CRAWLABLE_BETWEEN} minutes from the last crawl.")

      return {
        source: source,
        errors: source.errors.full_messages
      }
    end

    if Factories::NounFactory.new(source: source).register_nouns
      {
        source: source,
        errors: []
      }
    else
      {
        source: nil,
        errors: source.errors.full_messages
      }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
