module Types
  class NounType < Types::BaseObject
    field :id,    ID,      null: false
    field :word,  String,  null: false
    field :count, Integer, null: false
  end
end
