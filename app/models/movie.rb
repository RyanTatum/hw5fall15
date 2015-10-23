class Movie < ActiveRecord::Base
  Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_in_tmdb(movie)
    @results = Tmdb::Movie.find(movie)
    movies = Array.new
    @results.each do |x|
      new = Hash.new
      new[:id] = x.id
      new[:title] = x.title
      new[:release_date] = x.release_date
      new[:rating] = 'R'
      movies << new
    end
    return movies
  end
  
  def self.create_from_tmdb(tmdb_id)
    movie = Tmdb::Movie.detail(tmdb_id)
    new = Movie.new
    new.title=movie["title"]
    new.description=movie["overview"]
    new.release_date=movie["release_date"]
    new.rating = 'R'
    new.save()
    return new
  end
end
