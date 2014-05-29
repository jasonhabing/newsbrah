class SourcesController < ApplicationController
  before_filter :paper, :authenticate 

  def authenticate
  if request.subdomain == 'stage1'
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "nova"
  end
  end
  end

  def editfeed

    @bigstories = BigStory.find( :all, :order => "score DESC" , :limit => 100)

  end


  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all

    #display feed items in order of when they were published
    @feeditems = FeedItem.find( :all, :order => "created_at DESC" , :limit => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end


  def montana

    @bigs = BigStory.find(:all, :order => "score desc", :limit => 10)

  end
  
  def paper
    @subdomain = request.subdomain
    @bigs = BigStory.where(published: 1).order(:score).limit(10).reverse

  end


  def jade

    @timenow = Time.now.in_time_zone(Time.zone)
    @timedayback = @timenow - 1.days
    @timestart = Time.zone.local(@timenow.year, @timenow.month, @timenow.day)
    @yesterdaystart = @timestart - 1.days 

    @min = 10
    @bignewsgroup = BigStory.where(:created_at => @timedayback...@timenow).sort_by{|t| -t.feed_items.count }
    #@bignewsgroupyesterday = BigStory.where(:created_at => @yesterdaystart...@timestart).sort_by{|t| -t.feed_items.count }

  end



  def news
  

    @home_feed_days_total = 5 

  if params[:n] != nil
    @min = params[:n].to_i
  else
    @min = 10
  end

    @home_feed_days = params[:n].to_i
    datetime = Time.now - 5.days

    @bignewsgroup = BigStory.where(:created_at => datetime...DateTime.now)



  end



  def debug

    @feeditems = FeedItem.find( :all, :order => "created_at DESC" , :limit => 100)

    datetime = Time.now - 14.hours 
    @bignews = BigStory.includes(:feed_items).where(:created_at => datetime...DateTime.now).sort_by{|t| -t.feed_items.count }


  end


  def sourcereport
    @sources = Source.all

    #display feed items in order of when they were published
    @feeditems = FeedItem.find( :all, :order => "published DESC" , :limit => 100)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end

  def feed

    @sources = Source.all

    #display feed items in order of when they were published
    @feeditems = FeedItem.find( :all, :order => "published DESC" , :limit => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end

  end

  def bignews

    minlettercount = params[:small].to_i
    total = params[:n].to_i

    #declare how many feed items to run this on and the word letter counts to dismiss
   
    
    #make a bigarray and pull the latest feed items based on "Total"
    bigarray = Array.new
    latestfeeds = FeedItem.find(:all, :order => "published desc", :limit => total).reverse
   
    #go through each feed item, pull out words and add to big array
    latestfeeds.each do |feed|
      feedwordsarray = feed.title.split(" ").map { |s| s.to_s }
      feedwordsarray.each do |word|
        bigarray << word
      end
    end 

    #delete all "nil" items in the big array
  bigarray.delete_if {|x| x == nil}

  #get stats on word size
  @averagewordsize = 0
  allcounts = []
  
  bigarray.each do |word|
    size = word.size
    allcounts << size
  end
  stats = DescriptiveStatistics::Stats.new(allcounts)
  @mean = stats.mean
  @median = stats.median
  @mode = stats.mode
  @standarddev = stats.standard_deviation

    
    #make a new array that only has items with more than 3 letters
    morethanthree = Array.new
    bigarray.each do |word|
      if word.size > minlettercount
      morethanthree << word
      end
    end

    #setting minimum and maximum amounts for "big words" 
  #pull a full array of word counts
    countarray = Array.new
    morethanthree.each do |word|
      countarray << word.size
    end
    #for now, just set minimum and maximums but eventually should use something like standard deviation to  
    minamount = params[:min].to_i
    maxamount = params[:max].to_i

    #create an array to store all big words
    bigwordss = []

    @freqcountarray = []
    #create a new hash that has feeditem id and count of big words
  scorehash = []   
      latestfeeds.each do |feed|
        feeditemwords = feed.title.split(" ").map { |s| s.to_s }
        feeditemwords.delete_if {|x| x == nil}

        feeditemscore = 0
        feeditemwords.each do |word|
          count = morethanthree.count(word)
          @freqcountarray << count
          if count.between?(minamount, maxamount)
            bigwordss << word
            feeditemscore = feeditemscore + 1
          end
        end

      scorehash.push({"feedid"=>feed.id,"feedurl"=>feed.url,"feedtitle"=>feed.title,"score"=>feeditemscore})

      end

      sorted = scorehash.sort_by { |k| k["score"] }
      @sortednews = sorted.reverse
      @bigwords = bigwordss.uniq

        statsfreq = DescriptiveStatistics::Stats.new(@freqcountarray)
      @meanfreq = statsfreq.mean
      @medianfreq = statsfreq.median
      @modefreq = statsfreq.mode
       @standarddevfreq = statsfreq.standard_deviation

       @bigwordscount = []

      @bigwords.each do |word|
        count = morethanthree.count(word)
        @bigwordscount << count
      end


               bwstatsfreq = DescriptiveStatistics::Stats.new(@bigwordscount)
      @meanfreqbw = bwstatsfreq.mean
      @medianfreqbw = bwstatsfreq.median
      @modefreqbw = bwstatsfreq.mode
       @standarddevfreqbw = bwstatsfreq.standard_deviation



  end

  def top

      latestfeeds = FeedItem.find(:all, :order => "published desc", :limit => 600).reverse
      @stories = []

      latestfeeds.each do |feed|
        @stories.push({"title"=>feed.title,"id"=>feed.id, "feedsource"=>feed.feedsource})
      end

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

      

      #remove dupe storie sources
      @finalgroupings.each do |g|        
        g.each do |g2|
            item = FeedItem.where("id"=>g2)
            @s2 = item.first.feedsource
        end
      end


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
              na.push({"title"=>feed.first.title, "published"=>feed.first.published, "id"=>f,"url"=>feed.first.url, "feedsource"=>feed.first.feedsource, "bigstory"=>feed.first.big_story_id})
          end
          @all << na
      end
  
      @sortedall = @all.sort_by{|x| x.count}.reverse

  end


def trace

@storycount = 250  
@bigwordmin = 4
@bigwordlength = 1
@wordsize = 3

bigstories = BigStory.find(:all, :order => "id desc", :limit => @storycount)

   @bigstorybigwords = []  

   bigstories.each do |story|        
        bsbw = []    
        bigstorywords = []
        story.feed_items.each do |feed|
              feed.title.downcase.split(" ").map { |s| s.to_s }.each do |word|
                   unless word.length < @wordsize
                   bigstorywords << word
                   end
              end      
        end
        bigstorywords.each do |word|             
             if bigstorywords.count(word) > @bigwordlength
                  bsbw << word
             end
        end
        unless bsbw == nil
             @bigstorybigwords.push({"bigstoryid"=>story.id, "bigwordsarray"=>bsbw.uniq})
        end          
   end 
   
   @bigstoryids = []  

   @bigstorybigwords.each do |group|         
       id = group["bigstoryid"]
       bigwords = group["bigwordsarray"]       
               @bigstorybigwords.each do |bw|        
               bid = bw["bigstoryid"]
               commonwords = []
               bw["bigwordsarray"].each do |word1|
                 count = bigwords.count(word1)
                          if count > 0 && bid !=  id
                              commonwords << word1         
                           end
                         end
                         if commonwords.count > @bigwordmin    
                             pair = []
                             puts "created empty pair array"
                             pair << bid
                             puts "added #{bid} to pair"
                             pair << id
                             puts "added #{id} to pair"
                             @bigstoryids << pair
                             puts "#{@bigstoryids}"
                         end
               end                       
      end
      
      @finalgroups = @bigstoryids.each_with_object([]) do |e1, a|
        b = a.select{|e2| (e1 & e2).any?}
        b.each{|e2| e1.concat(a.delete(e2))}
        e1.uniq!
        a.push(e1)
      end
     

     @allbigs = BigStory.find(:all, :order => "id desc", :limit => 300)


     end




  def top3

    @bigstories = BigStory.all

    @bigstories2 = BigStory.find(:all, :order => "id desc", :limit => 40)

  end

 def top4

  timenumber = params[:time].to_i
  
  if timenumber == 0

  datetime = Time.now - 14.hours
  @bigstories = BigStory.includes(:feed_items).where(:created_at => datetime...DateTime.now).sort_by{|t| -t.feed_items.count }
 
  else 
  datetime = Time.now - timenumber.hours
  @bigstories = BigStory.includes(:feed_items).where(:created_at => datetime...DateTime.now).sort_by{|t| -t.feed_items.count }
  end

 end

 def top5

  timenumber = params[:time].to_i
  
  if timenumber == 0

  datetime = Time.now - 14.hours
  @bigstories = BigStory.includes(:feed_items).where(:created_at => datetime...DateTime.now).sort_by{|t| -t.feed_items.count }
 
  else 
  datetime = Time.now - timenumber.hours
  @bigstories = BigStory.includes(:feed_items).where(:created_at => datetime...DateTime.now).sort_by{|t| -t.feed_items.count }
  end



 end


  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/new
  # GET /sources/new.json
  def new
    @source = Source.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  def story

    @bigstory = BigStory.find(params[:id])

# inefficient trace code
#     @storycount = 250  
# @bigwordmin = 4  #should be 4
# @bigwordlength = 1  
# @wordsize = 3  #should be 3

# bigstories = BigStory.find(:all, :order => "id desc", :limit => @storycount)

#    @bigstorybigwords = []  

#    bigstories.each do |story|        
#         bsbw = []    
#         bigstorywords = []
#         story.feed_items.each do |feed|
#               feed.title.downcase.split(" ").map { |s| s.to_s }.each do |word|
#                    unless word.length < @wordsize
#                    bigstorywords << word
#                    end
#               end      
#         end
#         bigstorywords.each do |word|             
#              if bigstorywords.count(word) > @bigwordlength
#                   bsbw << word
#              end
#         end
#         unless bsbw == nil
#              @bigstorybigwords.push({"bigstoryid"=>story.id, "bigwordsarray"=>bsbw.uniq})
#         end          
#    end 
   
#    @bigstoryids = []  

#    @bigstorybigwords.each do |group|         
#        id = group["bigstoryid"]
#        bigwords = group["bigwordsarray"]       
#                @bigstorybigwords.each do |bw|        
#                bid = bw["bigstoryid"]
#                commonwords = []
#                bw["bigwordsarray"].each do |word1|
#                  count = bigwords.count(word1)
#                           if count > 0 && bid !=  id
#                               commonwords << word1         
#                            end
#                          end
#                          if commonwords.count > @bigwordmin    
#                              pair = []
#                              puts "created empty pair array"
#                              pair << bid
#                              puts "added #{bid} to pair"
#                              pair << id
#                              puts "added #{id} to pair"
#                              @bigstoryids << pair
#                              puts "#{@bigstoryids}"
#                          end
#                end                       
#       end
      
#       @finalgroups = @bigstoryids.each_with_object([]) do |e1, a|
#         b = a.select{|e2| (e1 & e2).any?}
#         b.each{|e2| e1.concat(a.delete(e2))}
#         e1.uniq!
#         a.push(e1)
#       end
     


#   @finalgroups.each do |group|
#     group.each do |gi|
#       if gi == @bigstory.id
#         @tr = group            
#       end
#     end
#   end



 
  end


  # POST /sources
  # POST /sources.json
  def create
    @source = Source.new(params[:source])

    respond_to do |format|
      if @source.save
        format.html { redirect_to @source, notice: 'Source was successfully created.' }
        format.json { render json: @source, status: :created, location: @source }
      else
        format.html { render action: "new" }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.json
  def update
    @source = Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html { redirect_to @source, notice: 'Source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url }
      format.json { head :no_content }
    end
  end
end




