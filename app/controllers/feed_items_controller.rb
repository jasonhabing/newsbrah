class FeedItemsController < ApplicationController
  
  def index
    @feeditem = FeedItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end

def create
    @feeditem = FeedItem.new(params[:source])

    respond_to do |format|
      if @feeditem.save
        format.html { redirect_to @feeditem, notice: 'Story was successfully created.' }
        format.json { render json: @feeditem, status: :created, location: @feeditem }
      else
        format.html { render action: "new" }
        format.json { render json: @feeditem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.json


  respond_to :html, :json 
  def update
    @feeditem = FeedItem.find(params[:id])
    @feeditem.update_attributes(params[:feed_item])
    respond_with @feeditem
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @feeditem = FeedItem.find(params[:id])
    @feeditem.destroy

    respond_to do |format|
      format.html { redirect_to big_story_url }
      format.json { head :no_content }
    end
  end

 def show
    @feeditem = FeedItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeditem }
    end
  end




  def calculate
  	puts "yes"
  end
  
end
