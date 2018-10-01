# == Schema Information
#
# Table name: hosts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_hosts_on_name  (name) UNIQUE
#

class Host < ApplicationRecord
  has_many :sources, dependent: :delete_all, autosave: true

  validates :name, presence: true
  validates :name, uniqueness: true
end
