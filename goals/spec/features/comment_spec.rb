require 'spec_helper'
require 'rails_helper'
# CRUD for comments
# user show page

feature "specific user show page" do

  scenario "show own user page" do
    make_user_with_goal("Tim","g1","Private")
    make_another_goal("g2","Public")
    click_link("Tim")

    expect(page).to have_content("g1")
    expect(page).to have_content("g2")
    expect(page).to have_link("back")
    expect(page).to have_link("Tim_g1")
    expect(page).to have_link("Tim_g2")
    expect(page).to have_button("destroy_Tim_g2")
    expect(page).to have_button("destroy_Tim_g1")
  end

  scenario "show other user's page" do
    make_user_with_goal("Tim","g1","Private")
    make_another_goal("g2","Public")
    logout_user

    make_user_with_goal("Julian","g3","Public")
    click_link("Tim")

    expect(page).to have_content("g2")
    expect(page).not_to have_content("g1")
    expect(page).not_to have_link("Tim_g2")
    expect(page).to have_link("back")
    expect(page).not_to have_content("g3")
  end
end

feature "create comments" do

  scenario "create comment for a goal" do
    create_goal_comment
  end

  scenario "create comment for a user" do
    create_user_comment
  end
end

feature "read comments" do

  scenario "goal comments appear in goal show page" do
    create_goal_comment
    expect(page).to have_content("c1")
    expect(page).to have_content("Julian")
  end

  scenario "user comments appear in user show page" do
    create_user_comment
    expect(page).to have_content("c1")
    expect(page).to have_content("Julian")
  end
end

feature "update comments" do
  scenario "edit goal comment from goal show page" do
    create_goal_comment
    click_link("Julian_c1")
    submit_comment("new body")
    expect(page).to have_content("new body")
  end

  scenario "edit user comment from user show page" do
    create_user_comment
    click_link("Julian_c1")
    submit_comment("new body")
    expect(page).to have_content("new body")
  end

  scenario "users can only edit their own comments" do
    create_user_comment
    logout_user
    make_user_with_goal("User3","g1","Private")
    visit(posts_url)
    click_link("Tim")
    expect(page).not_to have_link("Julian_c1")
  end
end

feature "destroy comments" do
  scenario "destroy goal comment from goal show page" do
    create_goal_comment
    click_button("destroy_Julian_c1")
    expect(page).not_to have_content("c1")
  end

  scenario "destroy user comment from user show page" do
    create_user_comment
    click_button("destroy_Julian_c1")
    expect(page).not_to have_content("c1")
  end

  scenario "users can only destroy their own comments" do
    create_user_comment
    logout_user
    make_user_with_goal("User3","g1","Private")
    visit(posts_url)
    click_link("Tim")
    expect(page).not_to have_button("destroy_Julian_c1")
  end
end
