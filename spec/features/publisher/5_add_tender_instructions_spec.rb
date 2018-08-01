# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  let!(:publisher) { FactoryBot.create(:publisher) }
  let!(:tender_instructions) { FactoryBot.build(:request_for_tender) }

  let!(:request_for_tender) do
    FactoryBot.create(:empty_request_for_tender,
                      publisher: publisher)
  end

  scenario 'should save the tender instructions of a request for tender' do
    given_a_publisher_who_has_logged_in

    when_they_add_the_tender_instructions_for_an_rft(request_for_tender,
                                                     tender_instructions)

    then_it_should_save_the_tender_instructions(request_for_tender,
                                                tender_instructions)
  end
end

def given_a_publisher_who_has_logged_in
  login_as publisher, scope: :publisher
end

def when_they_add_the_tender_instructions_for_an_rft(request_for_tender,
                                                     tender_instructions)
  visit request_for_tender_build_path(request_for_tender, :tender_instructions)

  editor = page.find(:css, '.trix-content')
  editor.click.set(tender_instructions.tender_instructions)

  click_button 'Save and continue'
  expect(page).to have_content 'Your changes have been saved!'
end

def then_it_should_save_the_tender_instructions(request_for_tender,
                                                tender_instructions)
  visit request_for_tender_build_path(request_for_tender,
                                      :tender_instructions)

  editor = page.find(:css, '.trix-content')
  expect(editor.value).to include tender_instructions.tender_instructions
end