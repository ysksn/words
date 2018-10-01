module Types
  class SourceType < Types::BaseObject
    field :crawled_at,  String,    null: true
    field :full_path,   String,    null: false
    field :nouns,       [NounType, null: true], null: false
  end
end
