module Admin::GenresHelper
	def is_valid(valid)
		if valid
			"有効"
		else
			"無効"
		end
	end
end
