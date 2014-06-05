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

        @storysize = params[:s].to_i

        if @storysize == 0
        @storysize = 8
        end


        @bigs = BigStory.where(published: 0).order(:created_at).reverse

  end

  def bulletfix


    @bigs = BigStory.where(published: 1).order("score DESC").limit(100)

  end

  def imgfetch

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
  rescue Exception
    puts "bad url"  
  end

  @story = BigStory.find(params[:id])

      @story.feed_items.each do |feed|
        url = feed.url.strip  
        unless url.include? '_' or url.include? 'hartfordcourant' or url.include? '?' or url.include? 'nytimes' or url.include? 'ChicagoTribune' or url.include? '~'
        if url_exist?(url)
          doc = Nokogiri::HTML(open(url))

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
          end
        
       
        end
      end
    end


 


  end



def edit
    @bigs = BigStory.where(published: 1).order("score DESC").limit(100)
end

def editfeed

	@story = BigStory.find(params[:id])
  @bigs = BigStory.find(:all, :order => "id desc", :limit => 40)    

end

def editdetails

	@story = BigStory.find(params[:id])
  @bigs = BigStory.find(:all, :order => "id desc", :limit => 30)    
  
  id = params[:id]

  @bigstory = BigStory.where(:id => id).first

  @images = []
  @descriptions = []

  @bigstory.feed_items.each do |feed|
    unless feed.desc == nil
      @descriptions << feed.desc
    end

    unless feed.imageurl == nil
      @images << feed.imageurl
    end

  end


end

end
