# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  #################### Quantity Surveyors Routes ##################

  devise_for :quantity_surveyors, path: 'quantity_surveyors', controllers: {
    confirmations: 'quantity_surveyors/confirmations',
    passwords: 'quantity_surveyors/passwords',
    registrations: 'quantity_surveyors/registrations',
    sessions: 'quantity_surveyors/sessions',
    unlocks: 'quantity_surveyors/unlocks'
  }

  get '/quantity_surveyors/dashboard',
      to: 'quantity_surveyors#dashboard',
      as: :quantity_surveyor_root

  resources :quantity_surveyors, only: %i[edit update]

  # Routes for create_tender
  get '/create_tender/:id',
      to: 'create_tender#edit_tender_information',
      as: :edit_tender_information

  patch '/create_tender/:id',
        to: 'create_tender#update_tender_information',
        as: :update_tender_information

  get '/create_tender/:id/documents',
      to: 'create_tender#edit_tender_documents',
      as: :edit_tender_documents

  patch '/create_tender/:id/documents',
        to: 'create_tender#update_tender_documents',
        as: :update_tender_documents

  get '/create_tender/:id/boq',
      to: 'create_tender#edit_tender_boq',
      as: :edit_tender_boq

  patch '/create_tender/:id/boq',
        to: 'create_tender#update_tender_boq',
        as: :update_tender_boq

  patch '/create_tender/:id/contract_sum_address',
        to: 'create_tender#update_contract_sum_address'

  get '/create_tender/:id/required_documents',
      to: 'create_tender#edit_tender_required_documents',
      as: :edit_tender_required_documents

  patch '/create_tender/:id/required_documents',
        to: 'create_tender#update_tender_required_documents',
        as: :update_tender_required_documents

  get '/create_tender/:id/payment_method',
      to: 'create_tender#edit_tender_payment_method',
      as: :edit_tender_payment_method

  patch '/create_tender/:id/payment_method',
        to: 'create_tender#update_tender_payment_method',
        as: :update_tender_payment_method

  patch '/create_tender/:id/details',
        to: 'create_tender#update_payment_details',
        as: :update_payment_details

  get '/create_tender/:id/contractors',
      to: 'create_tender#edit_tender_contractors',
      as: :edit_tender_contractors

  patch '/create_tender/:id/contractors',
        to: 'create_tender#update_tender_contractors',
        as: :update_tender_contractors

  resources :request_for_tenders, only: %i[create show update destroy]

  # Routes for bid

  get '/bids/:id',
      to: 'bids#required_documents',
      as: :bid_required_documents

  get '/bids/:id/boq',
      to: 'bids#boq',
      as: :bid_boq

  get '/bids/:id/other_documents',
      to: 'other_document_uploads#other_documents',
      as: :bid_other_documents

  get '/bids/:id/pdf_viewer/:required_document_upload_id',
      to: 'required_document_uploads#pdf_viewer',
      as: :view_pdf

  get '/bids/:id/image_viewer/:required_document_upload_id',
      to: 'required_document_uploads#image_viewer',
      as: :view_image

  get '/bids/:id/pdf_viewer/other/:other_document_id',
      to: 'other_document_uploads#pdf_viewer',
      as: :view_pdf_for_other_documents

  get '/bids/:id/image_viewer/other/:other_document_id',
      to: 'other_document_uploads#image_viewer',
      as: :view_image_for_other_documents

  patch '/bids/:required_document_upload_id/update_required_document',
        to: 'bids#update',
        as: :update_bid

  patch '/bids/:other_document_id/update_other_document',
        to: 'other_document_uploads#update',
        as: :update_other_document

  post '/bids/:id/disqualify',
       to: 'bids#disqualify',
       as: :disqualify_bid

  post '/bids/:id/undo_disqualify',
       to: 'bids#undo_disqualify',
       as: :undo_disqualify_bid

  post '/bids/:id/rate',
       to: 'bids#rate',
       as: :rate_bid

  #################### Contractors Routes ##################

  devise_for :contractors, path: 'contractors', controllers: {
    confirmations: 'contractors/confirmations',
    passwords: 'contractors/passwords',
    registrations: 'contractors/registrations',
    sessions: 'contractors/sessions',
    unlocks: 'contractors/unlocks'
  }

  get '/contractors/dashboard',
      to: 'contractors#dashboard',
      as: :contractor_root

  resources :contractors, only: %i[edit update]

  # Routes for purchase_tender

  get '/purchase_tender/:id',
      to: 'purchase_tender#portal',
      as: :purchase_tender

  post '/purchase_tender/:id',
       to: 'purchase_tender#purchase'

  get '/purchase_tender/:id/monitor_purchase',
      to: 'purchase_tender#monitor_purchase',
      as: :monitor_purchase

  get '/purchase_tender/complete_transaction',
      to: 'purchase_tender#complete_transaction',
      as: :complete_transaction

  # Routes for tender

  get '/tenders/:id',
      to: 'tenders#project_information',
      as: :tenders_project_information

  get '/tenders/:id/tender_documents',
      to: 'tenders#tender_documents',
      as: :tenders_tender_documents

  get '/tenders/:id/contractors_documents',
      to: 'tenders#contractors_documents',
      as: :tenders_contractors_documents

  get '/tenders/:id/boq',
      to: 'tenders#boq',
      as: :tenders_boq

  get '/tenders/:id/results',
      to: 'tenders#results',
      as: :tenders_results

  patch '/tenders/:id/save_contractors_documents',
        to: 'tenders#save_contractors_documents',
        as: :tenders_save_contractors_documents

  post '/tenders/:id/save_rates',
       to: 'tenders#save_rates'

  patch '/tenders/:id/submit_bid',
        to: 'tenders#submit_tender',
        as: :submit_tender

  get '/request_for_tenders/:id/compare_boq',
      to: 'request_for_tenders#compare_boq',
      as: :compare_boq

  resources :tenders, only: %i[update destroy]

  #################### Admin Routes ##################

  devise_for :admins, path: 'admins', controllers: {
    confirmations: 'admins/confirmations',
    passwords: 'admins/passwords',
    sessions: 'admins/sessions',
    unlocks: 'admins/unlocks'
  }

  mount RailsAdmin::Engine => '/adonai', as: :rails_admin
  mount ActionCable.server => '/cable'
end
