class AdminController < ApplicationController
	before_filter :authenticate 

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "novascotia"
  end
  end


def edit
    @bigs = BigStory.find(:all, :order => "score desc", :limit => 20)    
end

def editfeed

	@story = BigStory.find(params[:id])
    @bigs = BigStory.find(:all, :order => "score desc", :limit => 20)    

end

def editdetails

	@story = BigStory.find(params[:id])
    @bigs = BigStory.find(:all, :order => "score desc", :limit => 20)    

end

end
