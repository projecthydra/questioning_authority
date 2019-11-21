require 'spec_helper'

RSpec.describe Qa::LinkedData::RequestHeaderService do
  let(:request) { double }

  describe '#search_header' do
    context 'when optional params are defined' do
      let(:search_params) do
        {
          'subauthority' => 'person',
          'lang' => 'sp',
          'maxRecords' => '4',
          'context' => 'true',
          'performance_data' => 'true'
        }.with_indifferent_access
      end
      before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => 'de') }

      it 'uses passed in params' do
        expected_results =
          {
            context: true,
            performance_data: true,
            replacements: { 'maxRecords' => '4' },
            subauthority: 'person',
            user_language: ['sp']
          }
        expect(described_class.new(request: request, params: search_params).search_header).to eq expected_results
      end
    end

    context 'when none of the optional params are defined' do
      context 'and request does not define language' do
        before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => nil) }
        it 'returns defaults' do
          expected_results =
            {
              context: false,
              performance_data: false,
              replacements: {},
              subauthority: nil,
              user_language: nil
            }
          expect(described_class.new(request: request, params: {}).search_header).to eq expected_results
        end
      end

      context 'and request does define language' do
        before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => 'de') }
        it 'returns defaults with language set to request language' do
          expected_results =
            {
              context: false,
              performance_data: false,
              replacements: {},
              subauthority: nil,
              user_language: ['de']
            }
          expect(described_class.new(request: request, params: {}).search_header).to eq expected_results
        end
      end
    end
  end

  describe '#fetch_header' do
    context 'when optional params are defined' do
      let(:fetch_params) do
        {
          'subauthority' => 'person',
          'lang' => 'sp',
          'extra' => 'data',
          'even' => 'more data',
          'format' => 'n3',
          'performance_data' => 'true'
        }.with_indifferent_access
      end
      before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => 'de') }

      it 'uses passed in params' do
        expected_results =
          {
            format: 'n3',
            performance_data: true,
            replacements: { 'extra' => 'data', 'even' => 'more data' },
            subauthority: 'person',
            user_language: ['sp']
          }
        expect(described_class.new(request: request, params: fetch_params).fetch_header).to eq expected_results
      end
    end

    context 'when none of the optional params are defined' do
      context 'and request does not define language' do
        before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => nil) }
        it 'returns defaults' do
          expected_results =
            {
              format: 'json',
              performance_data: false,
              replacements: {},
              subauthority: nil,
              user_language: nil
            }
          expect(described_class.new(request: request, params: {}).fetch_header).to eq expected_results
        end
      end

      context 'and request does define language' do
        before { allow(request).to receive(:env).and_return('HTTP_ACCEPT_LANGUAGE' => 'de') }
        it 'returns defaults with language set to request language' do
          expected_results =
            {
              format: 'json',
              performance_data: false,
              replacements: {},
              subauthority: nil,
              user_language: ['de']
            }
          expect(described_class.new(request: request, params: {}).fetch_header).to eq expected_results
        end
      end
    end
  end
end