require 'rails_helper'
require 'spec_helper'

feature "create a goal" do

  scenario "has a create goal page" do
    make_user_with_goal("Tim","pass this spec")
  end

  scenario "shows user's goals after goal creation" do
    make_user_with_goal("Tim","pass this spec")
    expect(page).to have_content("pass this spec")

  end

end

feature "read a goal" do
  scenario "show all goals for a user" do
    make_user_with_goal("Julian","don't show this","Private")
    logout_user
    make_user_with_goal("Tim","pass this spec", "Private")
    make_another_goal("no, really pass it!")

    expect(page).to have_content("pass this spec")
    expect(page).to have_content("no, really pass it!")
    expect(page).not_to have_content("don't show this")
  end

  scenario "show public goals for other users" do
    make_user_with_goal("Julian","don't show this", "Private")
    make_another_goal("this is displayed")
    logout_user

    make_user_with_goal("Tim", "not here!")
    visit( goals_url )

    expect(page).to have_content("this is displayed")
    expect(page).not_to have_content("don't show this")
    expect(page).to have_content("not here!")

  end
end

feature "update a goal" do
  scenario "users can only update their own goals" do
    make_user_with_goal("Julian", "Julian's goal")
    logout_user

    make_user_with_goal("Tim", "Tim's goal")
    visit(goals_url)

    expect(page).to have_selector(:link, "Tim_Tim's goal")
    expect(page).not_to have_selector(:link, "Julian_Julian's goal")

  end

  scenario "has a update goal form" do
    make_user_with_goal("Tim", "Tim's goal")
    visit(goals_url)
    edit_goal("Tim_Tim's goal", "Private", "Complete")
  end

  scenario "show user's goals after update" do
    make_user_with_goal("Tim", "Tim's goal")
    make_another_goal("another goal")
    visit(goals_url)
    edit_goal("Tim_Tim's goal", "Private", "Complete")

    expect(page).to have_selector(:link, "Tim_some updates")
    expect(page).to have_selector(:link, "Tim_another goal")
  end
end

feature "delete a goal" do
  scenario "users can only delete their own goals" do
    make_user_with_goal("Julian", "Julian's goal")
    logout_user

    make_user_with_goal("Tim", "Tim's goal")
    visit(goals_url)

    expect(page).to have_selector(:button, "destroy_Tim_Tim's goal")
    expect(page).not_to have_selector(:button, "destroy_Julian_Julian's goal")

  end

  scenario "has a delete button" do
    make_user_with_goal("Tim", "Tim's goal")
    visit(goals_url)
    click_button("destroy_Tim_Tim's goal")
  end

  scenario "show user's goals after deletion" do
    make_user_with_goal("Tim", "Tim's goal")
    make_another_goal("another goal")
    visit(goals_url)
    click_button("destroy_Tim_Tim's goal")

    expect(page).not_to have_content("some updates")
    expect(page).to have_selector(:button, "destroy_Tim_another goal")
  end
end
