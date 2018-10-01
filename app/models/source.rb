# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  crawled_at :datetime
#  fragment   :string
#  full_path  :text             not null
#  path       :string           not null
#  query      :text
#  scheme     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  host_id    :integer          not null
#
# Indexes
#
#  index_sources_on_crawled_at             (crawled_at)
#  index_sources_on_full_path_and_host_id  (full_path,host_id) UNIQUE
#  index_sources_on_host_id                (host_id)
#  index_sources_on_host_id_and_full_path  (host_id,full_path) UNIQUE
#  index_sources_on_sc_pa_qu_fr_ho         (scheme,path,query,fragment,host_id) UNIQUE
#

class Source < ApplicationRecord
  MINIMUM_CRAWLABLE_BETWEEN = 30
  belongs_to :host
  has_many :nouns, dependent: :delete_all, inverse_of: :source, autosave: true

  validates :full_path, :path, :host, :scheme, presence: true
  validates :query,  length: { maximum: 2000 }, allow_blank: true
  validates :scheme, inclusion: { in: %w[https http] }
  validates :full_path, uniqueness: { scope: :host }
  validates :host, uniqueness: { scope: %i[scheme path query fragment] }

  before_validation :empty_to_root, if: proc { |source| source.path.empty? }

  def crawled
    self.crawled_at = Time.current
  end

  def crawlable?
    return true if crawled_at.nil?
    crawled_at < MINIMUM_CRAWLABLE_BETWEEN.minutes.ago
  end

  private

  def empty_to_root
    self.path = '/'
  end
end
