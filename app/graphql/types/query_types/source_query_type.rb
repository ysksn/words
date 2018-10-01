module Types
  module QueryTypes
    class SourceQueryType < QueryType
      field :words, [NounType], null: false do
        argument :full_path, String,  required: true
        argument :limit,     Integer, required: false, default_value: 10, prepare: ->(limit, _ctx) { [limit, 100].min }
        argument :order,     String,  required: false, default_value: :desc
      end

      def words(full_path:, limit:, order:)
        Source
          .find_by!(full_path: full_path)
          .nouns.limit(limit)
          .order(count: order)
      rescue ActiveRecord::RecordNotFound => e
        raise Errors::SourceNotFoundError, e.message
      end
    end
  end
end
