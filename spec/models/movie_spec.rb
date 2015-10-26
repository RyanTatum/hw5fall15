require 'rails_helper'
require 'spec_helper'

describe Movie do
    describe "searching Tmdb" do
        it 'should return a hash of the movies array for valid results' do 
            movies = Array.new
            movies[0] = Tmdb::Movie.new(:id => 12, :title => 'The', :release_date => '2000-12-12')
            movies[1] = Tmdb::Movie.new(:id => 16, :title => 'End', :release_date => '2015-12-12')
            expect(Tmdb::Movie).to receive(:find).with('check').and_return(movies)
            movies = Movie.find_in_tmdb('check')
            expect(movies[0][:id]).to eq(12)
            expect(movies[0][:title]).to eq('The')
            expect(movies[0][:release_date]).to eq('2000-12-12')
            expect(movies[0][:rating]).to eq('R')
            expect(movies[1][:id]).to eq(16)
            expect(movies[1][:title]).to eq('End')
            expect(movies[1][:release_date]).to eq('2015-12-12')
            expect(movies[1][:rating]).to eq('R')
        end 
        it 'should return an empty array if no movies are found' do
            expect(Tmdb::Movie).to receive(:find).with('check').and_return([])
            trial = Movie.find_in_tmdb('check')
            expect(trial).to eq([])
        end 
    end 
    describe 'adding from TMDb' do 
        it 'should create a movie' do
            trial = {'id' => 0, 'title' => 'movie', 'release_date' => '2000-12-12', 'overview' => 'overview'}
            expect(Tmdb::Movie).to receive(:detail).with(0).and_return(trial)
            trial = Movie.create_from_tmdb(0)
            expect(trial.title).to eq('movie')
            expect(trial.rating).to eq('R')
            expect(trial.release_date).to eq('2000-12-12')
            expect(trial.description).to eq('overview')
        end
    end
end
    