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
  #result = false
  #all("tr").each do |tr|
  #  result = false
  #  puts tr.text
  #  split_string.each do |rating|
  #    if tr.has_content?(rating)
  #        result = true
  #    end
  #  end
    
  #  if !result
  #      break
  #  end
  #end  
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  movie_collection = Movie.all
  movies_set = Set.new
  movie_collection.each { |movie| movies_set.add(movie[:title]) }
  #puts 'HERE--------------------'
  #puts movie_collection[0].title
  
  result_total = true

  all('tr').each do |tr|
    result = false
    text_str = tr.text
    puts text_str
    if text_str = 'Movie Title Rating Release Date More Info'
      next
    end
    
    movies_set.each do |movie|
      if text_str.include?(movie)
        #puts movie
        #puts "True"
        #puts movie.title
        result = true
      end
    end
    puts '---------------------------'
    if !result
      result_total = false
    end
    #puts movie.title
  end
  puts result_total
  expect(result_total).to be_truthy
end



