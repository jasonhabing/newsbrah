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
puts "Parsing feed items..."  
   @feeditems = FeedItem.find( :all, :order => "published DESC" )


     
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
	puts "feed items parsed"

    #make big array out of all words in the TitleWords database



    # update all feeds everytime the /sources page is loaded
    # this is causing a heavy load time and should be moved somewhere more efficient
    

  puts "done."
end