
module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)


Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then(/^I click "(.*?)"$/) do |link|
  click_link link
end

Then(/^I should see "(.*?)"$/) do |text|
    page.should have_content(text)
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"/ do |field, value| 
    fill_in( field, with: value )
end

When /^(?:|I )press "([^\"]*)"/ do |button|
    click_button(button)
end

Given(/^there are "(.*?)" shows$/) do |num_of_shows|
  num_of_shows.to_i.times do |num|
      FactoryGirl.create(:show, name: "Show #{num+1}")
  end
end

Given(/^there are "(.*?)" boards$/) do |num_of_boards|
   num_of_boards.to_i.times do |num|
   # unique_string = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
   FactoryGirl.create(:board, name: "Board #{num+1}")
  end
end

Given(/^there are "(.*?)" fireworks$/) do |num_of_fireworks|
  num_of_fireworks.to_i.times do |num|
      FactoryGirl.create(:firework, name: "Firework #{num+1}")
  end
end

Then(/^I should not see "(.*?)"$/) do |text|
   page.should_not have_content(text)
end

When /^(?:|I )follow "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

Given(/^I have created a show and added a track URL to "(.*?)"$/) do |name|
  FactoryGirl.create(:show, id: 1, name: name, track_url: "https://s3.amazonaws.com/fireworktracks/tracks/short.mp3" )
end

Then(/^the controls should not be visible on the page$/) do
  expect(page.evaluate_script("$('.controls').css('visibility');")).to eq 'hidden'
end

Given(/^I visit the shows page$/) do
  visit '/shows'
end

Then(/^I should see a timeline with the show id of (\d+)$/) do |id|
  expect(page.evaluate_script("$('#mytimeline').attr('data-show-id');")).to eq "1"
end

def path_to(page_name)

  # puts page_name
    case page_name

 
    when /the home\s?page/
      '/'

    when /the shows page/
      '/shows'

    when /the fireworks page/
      '/fireworks'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
end