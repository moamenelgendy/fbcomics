class ApiController < ApplicationController
def pages()
	@pages=Page.select("page_name").all;
	respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @pages}
        end
  end  
  def get ()
      backward(Integer(params[:limit]),Integer(params[:createdT]),params[:arr])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @queryy}
    end
  end

  def backward(limit=10,created_time=999999999999 , pages=[""] )
	if(pages.size >0)
		@queryy = Comics.where("created_time < #{created_time} AND page_name = \"#{pages[0]}\"").order("created_time DESC").group("src_big").first(limit)
		for i in 1..pages.size-1
		  @queryy = @queryy + Comics.where("created_time < #{created_time} AND page_name = \"#{pages[i]}\"").order("created_time DESC").group("src_big").first(limit)
		end
	end
    
  end
end
