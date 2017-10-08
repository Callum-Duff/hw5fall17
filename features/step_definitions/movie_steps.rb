# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  # Uncheck all boxes, find more elegant iterating solution later...
  uncheck('ratings_PG-13')
  uncheck('ratings_G')
  uncheck('ratings_PG')
  uncheck('ratings_NC-17')
  uncheck('ratings_R')
  
  split_string = arg1.split(', ')
  split_string.each { |rating| check("ratings_#{rating}")}
  split_string.each { |rating| puts "ratings_#{rating}" }
  
  click_button('ratings_submit')
  #pending  #remove this statement after implementing the test step
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  # First, parse the expected ratings
  split_string = arg1.split(', ')
  allowed_ratings = Set.new
  split_string.each { |rating| allowed_ratings.add(rating) }
  
  unallowed_ratings = Set.new ['G', 'PG', 'PG-13', 'NC-17', 'R']
  unallowed_ratings = unallowed_ratings - allowed_ratings
  #split_string.each { |rating| puts rating}
  
  # Now, check that the table matches the expected ratings
  result = true
  all("tr").each do |tr|
    text_str = tr.text
    puts tr.text
    unallowed_ratings.each do |rating|
      if text_str.include?(" #{rating} ")
        result = false
      end
    end
  end
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  movie_collection = Movie.all
  movies_set = Set.new
  movie_collection.each { |movie| movies_set.add(movie.title) }
  #puts 'HERE--------------------'
  #puts movie_collection[0].title
  result_total = true

  num_rows = 0
  all('tr').each do |tr|
    result = false
    text_str = tr.text
    
    if text_str == 'Movie Title Rating Release Date More Info'
      next
    end
    
    # If not in the header row, increment the row counter
    num_rows += 1
    
    # Make sure each movie in the table is also in the database
    movies_set.each do |movie|
      if text_str.include?(movie)
        result = true
      end
    end
    
    if !result
      result_total = false
    end
  end
  
  # Now check if the table lengths are the same
  if num_rows != movies_set.length
    result_total = false
  end

  expect(result_total).to be_truthy
end


#                                PART 3
# -------------------------------------------------------------------------
When /^I have opted to sort movies alphabetically$/ do
  click_on 'Movie Title'
end

When /^I have opted to sort movies by release date$/ do
  click_on 'Release Date'
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |first_movie, second_movie|
  match = /#{first_movie}.*#{second_movie}/m =~ page.body
  expect(match).to be_truthy
end

