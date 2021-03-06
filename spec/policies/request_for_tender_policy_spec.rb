# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestForTenderPolicy do
  subject { described_class.new(publisher, request_for_tender) }

  let(:resolved_scope) do
    described_class::Scope.new(publisher, RequestForTender.all).resolve
  end

  context 'publisher owns the request_for_tender, ' \
          'request_for_tender is published' do

    let(:publisher) { FactoryBot.create(:publisher) }

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher)
    end

    it 'includes request_for_tender in resolved scope' do
      expect(resolved_scope).to include(request_for_tender)
    end

    it { is_expected.to permit_action(:create) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:compare_boq) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'publisher owns the request_for_tender, ' \
          'request_for_tender is published' do

    let(:publisher) { FactoryBot.create(:publisher) }

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher)
    end

    it 'includes request_for_tender in resolved scope' do
      expect(resolved_scope).to include(request_for_tender)
    end

    it { is_expected.to permit_action(:create) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:compare_boq) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'publisher owns the request_for_tender, ' \
          'request_for_tender is published' do

    let(:publisher) { FactoryBot.create(:publisher) }

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end

    it 'excludes request_for_tender from resolved scope' do
      expect(resolved_scope).not_to include(request_for_tender)
    end

    it { is_expected.to permit_action(:create) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:compare_boq) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'publisher owns the request_for_tender, ' \
          'request_for_tender is published' do

    let(:publisher) { FactoryBot.create(:publisher) }

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end

    it 'excludes request_for_tender from resolved scope' do
      expect(resolved_scope).not_to include(request_for_tender)
    end

    it { is_expected.to permit_action(:create) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:compare_boq) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
