require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  describe 'POST /do_job' do
    it 'processes the sidekiq job', :aggregate_failures do
      Sidekiq::Testing.inline! do
        allow(HardJob).to receive(:perform_async).and_call_original

        expect do
          post '/do_job'
        end.to change(Job, :count).from(0).to(1)
        expect(HardJob).to have_received(:perform_async)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
