class SourcesController < ApplicationController

  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all

    #display feed items in order of when they were published
    @feeditems = FeedItem.find( :all, :order => "published DESC" , :limit => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
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

      latestfeeds = FeedItem.find(:all, :order => "published desc", :limit => 2000).reverse
      @stories = []

      latestfeeds.each do |feed|
        @stories.push({"title"=>feed.title,"id"=>feed.id, "feedsource"=>feed.feedsource})
      end

      @bigstorypairs = []
      @stories.each do |storyone|
        storyonetitle = storyone["title"]
        storyonesource = storyone["feedsource"]
        storyonearray = storyone["title"].split(" ").map { |s| s.to_s }
           @stories.each do |storytwo|
            storytwotitle = storytwo["title"]
            storytwosource = storytwo["feedsource"]

               storytwoarray = storytwo["title"].split(" ").map { |s| s.to_s }

               storyintersect = storyonearray & storytwoarray
               if storyintersect.size >= 4
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

      @pairs = []
      @bighash = []

      @finalgroupings = @bigstorypairs.each_with_object([]) do |e1, a|
        b = a.select{|e2| (e1 & e2).any?}
        b.each{|e2| e1.concat(a.delete(e2))}
        e1.uniq!
        a.push(e1)
      end

      #remove dupe storie sources
      @finalgroupings.each do |g|        
        g.each do |g2|
            item = FeedItem.where("id"=>g2)
            @s2 = item.first.feedsource
        end
      end


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




  end


  def updatefeeds
     @feeditems = FeedItem.find( :all, :order => "published DESC" )


     @sources = Source.all
     # create parsed words table
     @feeditems.each do |feed|

      feeditemid = feed[:id]

      unless TitleWords.exists?(:feeditemid => feeditemid)

        feedtitle = feed[:title] 
        parsedfeedtitle = feedtitle.split(" ").map { |s| s.to_s }
      
        #needs to be cleaned up using a for loop eventually

        word1 = parsedfeedtitle[0]
        word2 = parsedfeedtitle[1]
        word3 = parsedfeedtitle[2]
        word4 = parsedfeedtitle[3]
        word5 = parsedfeedtitle[4]
        word6 = parsedfeedtitle[5]
        word7 = parsedfeedtitle[6]
        word8 = parsedfeedtitle[7]
        word9 = parsedfeedtitle[8]
        word10 = parsedfeedtitle[9]
        word11 = parsedfeedtitle[10]
        word12 = parsedfeedtitle[11]
        word13 = parsedfeedtitle[12]
        word14 = parsedfeedtitle[13]
        word15 = parsedfeedtitle[14]
        word16 = parsedfeedtitle[15]
        word17 = parsedfeedtitle[16]
        word18 = parsedfeedtitle[17]
        word19 = parsedfeedtitle[18]
        word20 = parsedfeedtitle[19]

        newtitleword = TitleWords.new(:feeditemid => feeditemid, :word1 => word1, :word2 => word2, :word3 => word3, :word4 => word4, :word5 => word5, :word6 => word6, :word7 => word7, :word8 => word8, :word9 => word10, :word11 => word11, :word12 => word12, :word13 => word13, :word14 => word14, :word15 => word15, :word16 => word16, :word17 => word17, :word18 => word18, :word19 => word19, :word20 => word20)
        newtitleword.save
    
      end
    end

    # update all feeds everytime the /updatefeeds page is loaded
    @sources.each do |source|
      rss = source.rss
      FeedItem.update_from_feed(rss)
    end

    #creates a list of feeditems to be pulled out in CSV form
    @feeditemsforcsv = FeedItem.order(:title)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
      format.csv { render text: @feeditemsforcsv.to_csv}
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
