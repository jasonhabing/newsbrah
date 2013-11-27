class FeedItem < ActiveRecord::Base

	attr_accessible :author, :categories, :content, :published, :summary, :title, :url, :guid, :feedsource

  validates :title, length: { maximum: 250 }, presence: true
  validates :url, length: { maximum: 250 }, presence: true
  validates :author, length: { maximum: 250 }
  validates :guid, length: { maximum: 250 }, presence: true
  validates :feedsource, length: { maximum: 250 }


  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)

    unless feed.is_a? Fixnum    
    add_entries(feed.entries)

  end
  end


  
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end
  
  private
  

  def self.add_entries(entries)
    entries.each do |entry|
      
      unless FeedItem.exists?(:guid => entry.id)
      
      newfeeditem = FeedItem.new(
        :title => entry.title, 
        :url => entry.url, 
        :published => entry.published, 
        :author => entry.author, 
        :guid => entry.id, 
        :feedsource => URI.parse(entry.url).host
        )

      if newfeeditem.valid?  
        newfeeditem.save
      end

      end
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end




  # THIS IS THE OLD ADD ENTRIES METHOD, WHICH WAS REPLACED BY A METHOD WITH VALIDATIONS
  # def self.add_entries(entries)
  #   entries.each do |entry|
  #     unless exists? :guid => entry.id
  #       create!(
  #         :title         => entry.title,
  #         :url         	 => entry.url,
  #         :published 	   => entry.published,
  #         :author		     => entry.author,
  #         # :summary       => entry.summary,
  #         # :content 		 => entry.content,
  #         # :categories 	 => entry.categories,
  #         :guid          => entry.id,
  #         :feedsource    => URI.parse(entry.url).host
  #       )
  #     end
  #   end
  # end




end

