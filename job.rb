class Job < ActiveRecord::Base
	has_many :taggings
  	has_many :tags, through: :taggings
  	validates :title, :description, :requirements, :taggings,  presence: { strict: true }

	def self.tagged_with(name = "ruby")
		Tag.find_by_name!(name).jobs
	end

	def self.tag_counts
		Tag.select("tags.*, count(taggings.tag_id) as count").
		joins(:taggings).group("taggings.tag_id")
	end
	  
	def tag_list
		tags.map(&:name).join(", ")
	end
	  
	def tag_list=(names)
		self.tags = names.split(",").map do |n|
	    	Tag.where(name: n.strip).first_or_create!
	    end
	end
end
