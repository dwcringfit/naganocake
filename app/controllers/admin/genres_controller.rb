class Admin::GenresController < admin::bace

  def index
	  @genres = Genre.all
	  @genre = Genre.new
  end


  def create
	  @genre = Genre.new(genre_params)
	  if genre.save
	     @genres = Genre.all
	     redirect_to @genre
	  else
	     @genre = Genre.all
	     render 'index'
  end


  def edit
	@genre = Genre.find(params[:id])
  end


  def update
	  @genre = Genre.find(params[:id])
	  if @genre.update(genre_params)
		  @genres = Genre.all
		  redirect_to @genre
	  else
		  @genres = Genre.all
		  render 'index'
      end
   end




private

  def genre_params
	  params.require(:genre).permit(:list,:is_valid)
  end
end
