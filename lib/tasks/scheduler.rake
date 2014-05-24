desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do

@sources = Source.all

puts "Updating sources"
	@sources.each do |source|
	  puts "updating #{source.rss}"		
      rss = source.rss
      FeedItem.update_from_feed(rss)
    end
puts "Sources Updated" 
puts "....."

  puts "done."
end


task :make_news => :environment do

n = 1
while n < 10
new = BigStory.new
new.title = "A tiger escaped from the zoo"
new.save
n = n + 1
end


BigStory.find(:all, :order => "id desc", :limit => 5).reverse.each do |news|

@id = news.id

news.created_at = Time.now - 3.hours
news.save

i = 0

while i < 10 do

newfeeditem = FeedItem.new(:title => "A tiger has escaped from the zoo!", :guid => "tiger escaped", :url => "http://www.jasonhabing.com")
newfeeditem.big_story_id = @id
newfeeditem.save

i = i + 1

end
end
end


task :update_scores => :environment do

  @bigs = BigStory.find(:all, :order => "id desc", :limit => 100)
  @bigs.each do |big|
    count = big.feed_items.count
    age = (Time.now - big.created_at) / 3600
    score = (count - 1) / (age + 2) ** 1.8
    score.to_f
    big.score = score
    big.save
  end

end


task :pull_images => :environment do

require "open-uri"
require "net/http"
  def url_exist?(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    if res.kind_of?(Net::HTTPRedirection)
      url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
    else
      ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
    end
  rescue Errno::ENOENT
    false #false if can't find the server
  rescue SocketError => se
    false
  rescue Errno::ECONNREFUSED
    false
  end

puts "calculating big stories"
@bigstories = BigStory.find(:all, :order => "id desc", :limit => 3).reverse

  @bigstories.each do |story| 

    puts "BigStory #{story.id}, pulling feed items"
      story.feed_items.each do |feed|
        puts "pulling FeedItem #{feed.id}"
        url = feed.url.strip  
        if url_exist?(url)
          doc = Nokogiri::HTML(open(url))
          puts "doc made for feed item #{feed.id}"

          unless doc == nil or doc.at_css('meta[property="og:image"]') == nil
            p = doc.at_css('meta[property="og:image"]')['content']
            if p.length < 200
            feed.imageurl = p
            end

            unless doc == nil or doc.at_css('meta[property="og:description"]') == nil
              d = doc.at_css('meta[property="og:description"]')['content']
              feed.desc = d
            end
            
            
            feed.save
            puts "picture url stored for feed item #{feed.id}"
          end
        
       

        end
      end
  end

end



task :pull_descriptions => :environment do



end


#delete feeditems that don't have a bigstory id that are older than 20 days

task :clear_olditems => :environment do

# @count = FeedItem.where("created_at <= :created_at and big_story_id IS NULL",
#   {created_at: 60.days.ago}).count

# @allfeeditems = FeedItem.all.count

# puts "#{@allfeeditems} total FeedItems"
# puts "#{@count} older than 60 days and no big story"

FeedItem.where("created_at <= :created_at and big_story_id IS NULL",
  {created_at: 60.days.ago}).delete_all

# puts "deleted #{@count} feed items that were older than 60 days and had no big story"

end



#update feeds and find big items task


task :update_bignews => :environment do

latestfeeds = FeedItem.find(:all, :order => "created_at desc", :limit => 600).reverse
      @stories = []

      puts "pulling stories..."

      latestfeeds.each do |feed|
        @stories.push({"title"=>feed.title,"id"=>feed.id, "feedsource"=>feed.feedsource})
      end

      puts "comparing stories..."

      @bigstorypairs = []
      @stories.each do |storyone|
        storyonetitle = storyone["title"]
        storyonesource = storyone["feedsource"]
        storyonearray = storyone["title"].downcase.split(" ").map { |s| s.to_s }
        storyonearray2 = []
        storyonearray.each do |ar|
          if ar.size > 3
            storyonearray2 << ar
          end   
        end


           @stories.each do |storytwo|
            storytwotitle = storytwo["title"]
            storytwosource = storytwo["feedsource"]

               storytwoarray = storytwo["title"].downcase.split(" ").map { |s| s.to_s }
               storytwoarray2 = []
                 storytwoarray.each do |ar|
                    if ar.size > 3
                  storytwoarray2 << ar
                 end 
                end

               storyintersect = storyonearray2 & storytwoarray2
               intersectsize = storyintersect.size.to_f                             
               totalsize = (storyonearray2.size + storytwoarray2.size).to_f
               score = intersectsize / totalsize

               if storyintersect.size >= 3
               unless storytwoarray.size > 12
               unless storyonearray.size > 12
               if score >= 0.16
                  unless storytwosource == storyonesource
                  unless storyonetitle == storytwotitle                   
                        newarray = []
                        newarray << storyone["id"]
                        newarray << storytwo["id"]
                        puts "adding #{storyone} and #{storytwo} to big stories"
                        @bigstorypairs << newarray 
                        end

                  end
                end  
              end
              end
              end
          end
      end

      @pairs = []



      @bighash = []

      puts "creating final groupings..."

      @finalgroupings = @bigstorypairs.each_with_object([]) do |e1, a|
        b = a.select{|e2| (e1 & e2).any?}
        b.each{|e2| e1.concat(a.delete(e2))}
        e1.uniq!
        a.push(e1)
      end

      puts "removing duplicate story sources..."
      #remove dupe storie sources
      @finalgroupings.each do |g|        
        g.each do |g2|
            item = FeedItem.where("id"=>g2)
            @s2 = item.first.feedsource
        end
      end

      puts "putting final groupings bigger than five together"
      @fg = []
      @finalgroupings.each do |g|
        if g.count >= 5
          @fg << g
        end
      end


      @all = []
      @fg.each do |f|
          na = []
          f.each do |f|
              feed = FeedItem.where("id"=>f)
              id = f
              na.push({"title"=>feed.first.title, "published"=>feed.first.published, "id"=>f,"url"=>feed.first.url, "feedsource"=>feed.first.feedsource})
          end
          @all << na
      end
  
      @sortedall = @all.sort_by{|x| x.count}.reverse

@sortedall.each do |b|
  
  bigstoryids = []
  b.each do |b1|
    feeditem = FeedItem.where("id" => b1["id"]).first
    puts "#{feeditem}"
    puts "#{feeditem.big_story}"
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    bigstoryids << feeditem.big_story_id  
  end

  uniquestory = bigstoryids.uniq
  puts "**************BigStoryArray*********"
  puts "#{uniquestory}"

  puts "getting ready to make big stories"
  #if none of the feed items belong to a big story
  if uniquestory.count == 1 and uniquestory.first == nil

  #make a new big story
    puts "$$$$$$$ Create a new bigstory $$$$$$"
    newbig = BigStory.new
    newbig.score = 0.0
    newbig.save
    newbig = BigStory.last
    puts "$$$$$$ Created new bigstory #{newbig} $$$$$$" 

    storydates = []

  #put each feed item in the new big story
    b.each do |b1|
    feeditem = FeedItem.where("id" => b1["id"]).first
    storydates << feeditem.created_at
    feeditem.big_story = newbig
    feeditem.save
    puts "%%%%%%%% Putting #{feeditem.title} in big story id #{newbig.id} %%%%%%"
    end


    newbig.breakingdate = storydates.min
    newbig.latestdate = storydates.max 
    newbig.save

  end

  #if the the array contains a number
  if uniquestory.count == 1 and uniquestory.first.is_a? Integer
    uniquestorynum = uniquestory.first
    
    #nothing happens
    puts "this array contains just one number, no database writing needed"
  end

  #if the array has nil and a number
  if uniquestory.count == 2 

    uniquenum = uniquestory.find { |x| not x.nil? }

    bignewsitem = BigStory.where("id" => uniquenum).first

    storydates2 = []

    b.each do |b1|
  
     #make all the nil items the same as the first number
     feeditem = FeedItem.where("id" => b1["id"]).first
     if feeditem.big_story == nil
       feeditem.big_story = BigStory.where("id" => uniquenum).first
       feeditem.save       
       storydates2 << feeditem.created_at
       puts "^^^^^^^^^^^^^^ Just wrote #{feeditem.title} into big story #{uniquenum} ^^^^^^^^^^^^"
     end  
  
    end

    unless storydates2 == nil 
    bignewsitem.latestdate = storydates2.max     
    end

  end

    #if the array has nil and greater than 2 numbers
  if uniquestory.count >= 2 

    uniquenum = uniquestory.find { |x| not x.nil? }

    bignewsitem = BigStory.where("id" => uniquenum).first

    storydates2 = []

    b.each do |b1|
  
     #make all the items the same as the first number
     feeditem = FeedItem.where("id" => b1["id"]).first
       feeditem.big_story = BigStory.where("id" => uniquenum).first
       feeditem.save       
       storydates2 << feeditem.created_at
       puts "^^^^^^^^^^^^^^ Just wrote #{feeditem.title} into big story #{uniquenum} ^^^^^^^^^^^^"
  
    end

    unless storydates2 == nil 
    bignewsitem.latestdate = storydates2.max     
    end

  end


end

@bigstories = BigStory.find(:all, :order => "id desc", :limit => 80)


@bigstories.each do |story| 
  bigarray = []
  unless story.feed_items == nil
    story.feed_items.each do |feed|
      feedwordsarray = feed.title.downcase.split(" ").map { |s| s.to_s }
      feedwordsarray.each do |word|
        bigarray << word
      end
    end 

    bigarray.delete_if {|x| x == nil}

    scoreshash = []

    story.feed_items.each do |feed|
      feedwordsarray = feed.title.downcase.split(" ").map { |s| s.to_s }
      count = 0
      feedwordsarray.each do |word|
        count = count + bigarray.count(word)
      end
      puts "#{count}"
      scoreshash.push({"feedid"=>feed.id,"score"=>count})
    end

    unless scoreshash == nil 
      puts "got to scorehash"
      bestid = scoreshash.sort_by { |k| k["value"] }
      puts "created bestid"
      unless bestid == nil
      puts "creating bestid2..."
      unless bestid.last == nil
      bestid2 = bestid.last["feedid"]
      puts "made bestid"
      besttitle = FeedItem.where("id" => bestid2).first.title
      puts "best title is #{besttitle}" 
      story.title = besttitle
      story.save
      puts "story #{story.id} title saved as #{story.title}"
    end
    end
    end
    end
end


end








