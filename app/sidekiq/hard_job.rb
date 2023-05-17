class HardJob
  include Sidekiq::Job

  def perform(*_args)
    job = Job.new(job_name: self.class.to_s)

    job.save
  end
end
