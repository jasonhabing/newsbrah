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

#update feeds and find big items task


task :update_bignews => :environment do

latestfeeds = FeedItem.find(:all, :order => "published desc", :limit => 600).reverse
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
        storyonearray = storyone["title"].split(" ").map { |s| s.to_s }
        storyonearray2 = []
        storyonearray.each do |ar|
          if ar.size > 2
            storyonearray2 << ar
          end   
        end


           @stories.each do |storytwo|
            storytwotitle = storytwo["title"]
            storytwosource = storytwo["feedsource"]

               storytwoarray = storytwo["title"].split(" ").map { |s| s.to_s }
               storytwoarray2 = []
                 storytwoarray.each do |ar|
                    if ar.size > 2
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

      puts "putting final groupings bigger than three together"
      @fg = []
      @finalgroupings.each do |g|
        if g.count >= 3
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

  #if none of the feed items belong to a big story
  if uniquestory.count == 1 and uniquestory.first == nil

  #make a new big story
    puts "$$$$$$$ Create a new bigstory $$$$$$"
    newbig = BigStory.new
    newbig.save
    newbig = BigStory.last
    puts "$$$$$$ Created new bigstory #{newbig} $$$$$$" 

  #put each feed item in the new big story
    b.each do |b1|
    feeditem = FeedItem.where("id" => b1["id"]).first
    feeditem.big_story = newbig
    feeditem.save
    puts "%%%%%%%% Putting #{feeditem.title} in big story id #{newbig.id} %%%%%%"
    end

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

    b.each do |b1|
  
     #make all the nil items the same as the first number
     feeditem = FeedItem.where("id" => b1["id"]).first
     if feeditem.big_story == nil
       feeditem.big_story = BigStory.where("id" => uniquenum).first
       puts "^^^^^^^^^^^^^^ Just wrote #{feeditem.title} into big story #{uniquenum} ^^^^^^^^^^^^"
     end  
    end
  end


end


end


