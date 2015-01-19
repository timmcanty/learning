require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    make_user
  end

  feature "signing up a user" do

    scenario "shows username on the homepage after signup" do
      make_user
      visit( goals_url)
      expect(page).to have_content("Julian")
    end


  end

end

feature "logging in" do

  scenario "shows username on the homepage after login" do
    make_user
    login_user
  end

end

feature "logging out" do

  scenario "begins with logged out state" do
    visit( goals_url )
    expect(page).to have_content("Please Login")
  end

  scenario "doesn't show username on the homepage after logout" do
    make_user
    login_user
    logout_user
    expect(page).to_not have_content("Julian")
  end

end
