class BigStoriesController < ApplicationController
  before_filter :authenticate 

  def authenticate
  unless request.subdomain == 'stage1'
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "nova"
  end
  end
  end


def index
    @story = BigStory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end

def new
    @story = BigStory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @source }
    end
  end

def create
    @story = BigStory.new(params[:big_story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.json


  respond_to :html, :json 
  def update
    @story = BigStory.find(params[:id])
    @story.update_attributes(params[:big_story])
    respond_with @story
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @story = BigStory.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to big_story_url }
      format.json { head :no_content }
    end
  end

 def show
    @story = BigStory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

end
