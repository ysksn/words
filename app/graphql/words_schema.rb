class WordsSchema < GraphQL::Schema
  mutation(Types::Mutation)
  query(Types::QueryTypes::SourceQueryType)
end
