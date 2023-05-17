class JobsController < ApplicationController
  def home
  end

  def do_job
    HardJob.perform_async
  end
end
