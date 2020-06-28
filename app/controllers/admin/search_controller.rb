class Admin::SearchController < Admin::Base

	def search
		range = params[:range]
		search_word = params[:search_word]

		if range == "1"
			@clients = Client.search(search_word)
		elsif range == "2"
			@items = Item.search(search_word)
		end
	end

end
