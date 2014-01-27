require 'spec_helper'

describe "login", js: true do
  before :each do
    FactoryGirl.create :user, {email: 'user@example.com',
                               password:              'caplin',
                               password_confirmation: 'caplin'}
    visit root_path
    find('#login-trigger').click
  end

  it "logs in with valid user" do
    fill_login_form 'user@example.com', 'caplin'
    click_login
    assert has_selector?("#logout")
  end

  it "does not login with invalid password" do
    fill_login_form 'user@example.com', 'caplin2'
    click_login
    assert has_no_selector?("#logout")
  end

  it "does not login with invalid email" do
    fill_login_form 'user2@example.com', 'caplin'
    click_login
    assert has_no_selector?("#logout")
  end
end

def fill_login_form(email, name)
  within("#loginform") do
    fill_in 'email',    with: email
    fill_in 'password', with: name
  end
end

def click_login
  find("input[name='login']").click
end