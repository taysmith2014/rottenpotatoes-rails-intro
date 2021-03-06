class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings 
    
    @sort = params[:sort] || session[:sort] || nil
    @ratings = params[:ratings] || session[:ratings] || @all_ratings
    
    if (params[:sort] != session[:sort]) || (params[:ratings] != session[:ratings])
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      return redirect_to sort: @sort, ratings: @ratings
    end
    
    if @sort == "title"
      @ratings ? @movies = Movie.where(rating: @ratings.keys).order(@sort) : @movies = Movie.order(@sort)
      @title_class = "hilite"
    elsif @sort == "release_date"
      @ratings ? @movies = Movie.where(rating: @ratings.keys).order(@sort) : @movies = Movie.order(@sort)
      @date_class = "hilite"
    else 
      @ratings ? @movies = Movie.where(rating: @ratings.keys).order(@sort) : @movies = Movie.all
    end  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
