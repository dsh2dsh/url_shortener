require 'securerandom'

# This class describes a shortened URL.
#
# [url] an URL where to redirect.
#
# [slug] a random or not random string, which is a part of shortened URL.
#
# [expire_at] is a datetime when this link should be expired and will
#             not be valid. Can be nil and such links will not be
#             expired at all.
#
# If slug is nil it will be auto generated random string.
class Link < ApplicationRecord
  validates :url, :slug, :uuid, presence: true
  validates :slug, uniqueness: true
  validates :url, format: { with: %r{\Ahttps?://.+},
                            message: 'must begin with a HTTP protocol' }

  before_validation do
    self.slug = SecureRandom.alphanumeric(10) if slug.blank?
  end

  # Deletes all expired links.
  def self.expire_links
    delete_by('expire_at IS NOT NULL AND expire_at < ?', Time.now)
  end
end