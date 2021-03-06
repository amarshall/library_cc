require 'spec_helper'

feature 'invalid parameters', js: true do
  fixtures :all

  scenario 'invalid book add' do
    login_in_as users(:admin)
    visit new_book_path
    click_button 'Add the book'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Please review the errors below'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Author can't be blank"
    expect(page).to have_content "Publisher can't be blank"
    expect(page).to have_content "Price can't be blank"
  end

  scenario 'invalid book edit' do
    login_in_as users(:admin)
    visit edit_book_path(books(:book1))
    fill_in 'Enter the title for the book', with: ''
    click_button 'Save'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Please review the errors below'
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'invalid user add' do
    login_in_as users(:admin)
    visit new_user_path
    click_button 'Add User'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Please review the errors below'
    expect(page).to have_content "First name can't be blank"
    expect(page).to have_content "Last name can't be blank"
  end

  scenario 'invalid user edit' do
    login_in_as users(:admin)
    visit edit_user_path(users(:employee2))
    fill_in 'Enter First Name', with: ''
    click_button 'Update user'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Please review the errors below'
    expect(page).to have_content "First name can't be blank"
  end
end
