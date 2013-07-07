class ComicsController < ApplicationController

 task :turn_off_alarm do
    puts "Turned off alarm. Would have liked 5 more minutes, though."
  end


def subString(x,y,m)
        n=""
        for i in x..y
            n = n+m[i]
        end
        return n
    end
    
    def add_to_pages
        Page.create({:page_id=>"263629920398785" , :page_name=>"Asa7be Sarcasm Society" , :last_visited=>0})
        Page.create({:page_id=>"386702438041665" , :page_name=>"Handasa Sarcasm Society" , :last_visited=>0})
    end


    
    def add_one_page ()
		Page.create({:page_id=>params[:pageID] , :page_name=>params[:pageName] , :last_visited=>0})
    end
    
    def delete_one_page ()
		@page = Page.where("page_id = \"#{params[:pageID]}\" ")
		Page.delete(@page)
    end
    
    
    
    def delete_related_comics ()
		@comics = Comics.where("page_name = \"#{params[:pageName]}\" ")
		Comics.delete(@comics)
    end
    
    def delete_All_pages
        Page.delete_all
    end
    
    def delete_All_comics
        Comics.delete_all
    end
	
    def push_to_DB
    
        @oauth = Koala::Facebook::OAuth.new("111645512357915","42e87c3eac658eb90e04cd6164ba9079", "http://127.0.0.1:3000/")
        @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
          
        count = 0 #for filling the database then it must be removed
    
        page=Page.all
    	#      puts @oauth.get_app_access_token
         for i in 0..page.size-1
            createdTime = 999999999999
    	      temp=Integer(page[i].last_visited)
            begin
    #           puts count
                photos=@graph.fql_query("SELECT attachment,message,created_time FROM stream WHERE source_id = #{page[i].page_id} 
                and created_time < #{createdTime} and created_time> #{page[i].last_visited} limit  100")
      
                photos.each {|x|
                    if(temp<x["created_time"])
                       temp=x["created_time"]
                    end
                    if(x["attachment"] !=nil)     
                       media = x["attachment"]["media"]
                       if (media !=nil && media.size>0 && media[0]!=nil)
                           photo = media[0]["photo"]
                           if(photo!=nil)
                              pid=photo["pid"]
                              src = @graph.fql_query("SELECT src_big , src_small , like_info , comment_info FROM photo WHERE pid = '#{pid}'")
                              puts src
                              src_big=src[0]["src_big"]
                              src_small=src[0]["src_small"]
                              likes=(src[0]["like_info"])["like_count"]
                              comments=(src[0]["comment_info"])["comment_count"]
                              created=x["created_time"]
                              title=x["message"]
                              pagen=page[i].page_name 
        		                  Comics.create({:comments=>comments, :created_time=>created, :likes=>likes, 
        		                                 :page_name=>pagen,:page_id=>page[i].page_id,                     
                                             :src_big=>src_big, :src_small=>src_small, :title=>title})
    			
                              #push into comics module
                           end
                       end
    	              end
                    createdTime = x["created_time"]
                }
                count += 1
            end while photos.size>0 && count < 2
            count = 0;
            page[i].update_attributes(:last_visited=>temp , :page_name=>page[i].page_name , :page_id=>page[i].page_id) #save into pages module
        end 
    end
end
