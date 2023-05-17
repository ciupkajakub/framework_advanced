require 'rails_helper'
RSpec.describe HardJob, type: :job do
  describe '#perform' do
    it 'saves the job class name to the database whenever the job is performed' do
      sidekiq_job = described_class.new

      expect { sidekiq_job.perform }.to change(Job, :count).from(0).to(1)
      expect(Job.first.job_name).to eq(described_class.to_s)
    end
  end
end
