class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

  def self.find_by_slug(slug)
      self.all.find{ |instance| instance.slug == slug }
    end

  def slug
      self.username.gsub(" ", "-").downcase
    end
end
