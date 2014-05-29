class AdminController < ApplicationController
	before_filter :authenticate 

  def authenticate
  unless request.subdomain == 'stage1'
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "nova"
  end
  end
  end

  def unpublished

        @bigs = BigStory.where(published: 0).order(:created_at).reverse

  end


def edit
    @bigs = BigStory.where(published: 1).order(:score).limit(10).reverse
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
