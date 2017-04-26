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
        if (not (params[:orderby] or params[:ratings])) and (session[:ratings] or session[:orderby])
            params[:ratings] = session[:ratings]
            params[:orderby] = session[:orderby]
            redirect_to root_path(params)
        end
        if params[:orderby]
            session[:orderby] = params[:orderby]
        end
        @all_ratings = Movie.pluck(:rating).uniq
        if not params[:ratings]
            session[:ratings] = Hash[@all_ratings.map { |i| [i,1] }] unless session[:ratings]
        else
            session[:ratings] = params[:ratings]
        end
        filter =  session[:ratings].keys
        @movies = Movie.where(:rating => filter).order(session[:orderby])
        @order = session[:orderby] ? session[:orderby] : ""
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

    def updatevies_pa
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
