# == Schema Information
#
# Table name: nouns
#
#  id         :integer          not null, primary key
#  count      :integer          not null
#  word       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  source_id  :integer          not null
#
# Indexes
#
#  index_nouns_on_count               (count)
#  index_nouns_on_source_id           (source_id)
#  index_nouns_on_source_id_and_word  (source_id,word) UNIQUE
#  index_nouns_on_word_and_source_id  (word,source_id) UNIQUE
#

class Noun < ApplicationRecord
  belongs_to :source

  validates :count, :word, :source, presence: true
end
