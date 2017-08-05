class JobProcessor

  def order_jobs(jobs)
    return "" if jobs.empty?
    string_to_array_filter(jobs)
  end

  private

  def string_to_array_filter(jobs)
    array_of_jobs = jobs.split(",")
    array_of_jobs.map { |job| job.lstrip[0] }.join("")
  end
end
