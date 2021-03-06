# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildTenderPolicy do
  subject { described_class.new(contractor, tender) }

  let(:contractor) { FactoryBot.create(:contractor) }

  context 'contractor does not own the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has not been submitted' do

    let(:tender) do
      FactoryBot.create(:tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end

  context 'contractor does not own the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender, :submitted)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end


  context 'contractor does not own the tender, ' \
          'the tender has been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end

  context 'contractor does not own the tender, ' \
          'the tender has been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender,
                        :submitted)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end


  context 'contractor owns the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        contractor: contractor)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end

  context 'contractor owns the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        :submitted,
                        contractor: contractor)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end


  context 'contractor owns the tender, ' \
          'the tender has been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender,
                        contractor: contractor)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:create) }
  end

  context 'contractor owns the tender, ' \
          'the tender has been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        :purchased,
                        :submitted,
                        contractor: contractor)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:create) }
  end
end
