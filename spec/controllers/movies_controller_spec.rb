require	'rails_helper'
require 'spec_helper'
describe MoviesController do
    describe 'searching TMDb' do
        before :each do
            @fake_results = [double('movie1'), double('movie2')]
        end
        it 'should call the TMDb search' do
            expect(Movie).to receive(:find_in_tmdb).with('Matilda').and_return(@fake_results)
            post :search_tmdb, {:search_tmdb => {'input' => 'Matilda'}}
        end
        describe 'after a correct search' do
            before :each do 
                expect(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
                post :search_tmdb, {:search_tmdb => {'input' => 'Ted'}}
            end
            
            it 'should select the Search Results' do 
                expect(response).to render_template('search_tmdb')
            end
            
            it 'should make the results available' do 
                expect(assigns(:matching_movies)).to be @fake_results
                expect(assigns(:input)).to eq 'Ted'
            end
        end
        
        describe 'after an incorrect search' do 
            it 'should send the user to the movie path if the search is empty' do 
                post :search_tmdb, {:search_tmdb => {'input' => ''}}
            end 
            after :each do 
                expect(response).to redirect_to(movies_path)
                expect(flash[:notice]).to eq("Invalid search term")
            end 
        end
        
        describe 'with no results' do
            # the response could be nil or it could be empty
            it 'should send to movie path if the results are empty' do 
                expect(Movie).to receive(:find_in_tmdb).with('Matilda').and_return([])
            end 
            after :each do 
                post :search_tmdb, {:search_tmdb => {'input' => 'Matilda'}}
                expect(response). to redirect_to(movies_path)
                expect(flash[:notice]).to eq('No matching movies were found on TMDb')
            end
        end
    end
    
    describe 'add from tmdb' do 
        describe 'when no movies are checked' do 
            it 'should send the user to the movie path when empty' do
                post :add_tmdb, {:tmdb_movies => {}}
            end 
           after :each do 
                expect(flash[:notice]).to eq('No movies selected')
            end
        end 
        
        it 'should save selected movies to the database' do
            post :add_tmdb, {:tmdb_movies => {1 => 1, 2 => 1}}
            expect(flash[:notice]).to eq('Movies successfully added to RottenPotatoes')
        end 
        after :each do 
            expect(response).to redirect_to(movies_path)
        end
    end
end