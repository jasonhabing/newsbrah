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


    #make big array out of all words in the TitleWords database



    # update all feeds everytime the /sources page is loaded
    # this is causing a heavy load time and should be moved somewhere more efficient
    @sources.each do |source|
      rss = source.rss
      FeedItem.update_from_feed(rss)
    end

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
