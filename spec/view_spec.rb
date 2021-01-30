require 'spec_helper'

RSpec.describe 'index page', type: :feature do
  before(:all) do
    @u1 = User.create(name: 'u1', email: 'user1@u1.com', password: '111111', password_confirmation: '111111')
    @u1.save

    @u2 = User.create(name: 'u2', email: 'user2@u2.com', password: '222222', password_confirmation: '222222')
    @u2.save

    @u3 = User.create(name: 'u3', email: 'user3@u3.com', password: '333333', password_confirmation: '333333')
    @u3.save
  end

  before(:each) do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '111111'
    click_button 'Log in'
  end

  scenario 'index page' do
    find('a', text: 'Sign out').click
    visit '/'
    expect(page).to have_content('Sign in')
  end
  scenario 'visit sign up page' do
    find('a', text: 'Sign out').click
    visit '/users/sign_up'
    expect(page).to have_content('Sign up')
  end

  scenario 'test login event' do
    page.should have_content('Signed in successfully.')
  end

  scenario 'test post event' do
    fill_in 'post_content', with: 'my first post'
    click_button 'Save'
    page.should have_content('my first post')
  end

  scenario 'test show user' do
    find('a', text: 'All users').click
    page.should have_content('Name: user2')
  end

  scenario 'test frienship' do
    find('a', text: 'All users').click
    click_button 'invite2'
    f1 = Friendship.find_by(user_id: 1, friend_id: 2, confirmed: nil)
    expect(f1.valid?).to eq(true)
  end

  scenario 'test sign out' do
    find('a', text: 'Sign out').click
    page.should have_content('You need to sign in or sign up before continuing.')
  end

end