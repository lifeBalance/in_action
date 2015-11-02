require 'rails_helper'

RSpec.feature 'Users can view tickets' do
  before do
    # Create an author-user
    author = FactoryGirl.create(:user)
    # Create one project and a nested ticket
    sublime = FactoryGirl.create(:project, name: 'Sublime Text 3')
    FactoryGirl.create(:ticket,
      project: sublime,
      author: author,
      name: 'Make it shiny!',
      description: 'Gradients! Starbusts! Oh my!')

    # Create another project and a nested ticket
    ie = FactoryGirl.create(:project, name: 'Internet Explorer')
    FactoryGirl.create(:ticket,
      project: ie,
      name: 'Standards compliance',
      description: "Isn't a joke.")

    visit '/'
  end

  scenario 'for a given project' do
    click_link('Sublime Text 3')

    expect(page).to have_content 'Make it shiny!'
    expect(page).to_not have_content 'Standards compliance'

    click_link('Make it shiny!')
    within('#ticket h2') do
      expect(page).to have_content 'Make it shiny!'
    end

    expect(page).to have_content 'Gradients! Starbusts! Oh my!'
  end
end
