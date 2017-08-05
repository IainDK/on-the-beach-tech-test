class JobProcessor

  def order_jobs(jobs)
    return "" if jobs.empty?
    ordered_job_array(jobs)
  end

  private

  def string_to_array(jobs)
    array_of_jobs = jobs.split(",")
    array_of_jobs.map { |job| job.lstrip }
  end

  def job_hash(jobs)
    all_jobs = {}
    string_to_array(jobs).each do |job|
      all_jobs[job[0]] = job[-1]
    end
    all_jobs
  end

  def ordered_job_array(jobs)
    job_array = []
    dependencies = job_hash(jobs).values
    job_array << dependencies
    job_hash(jobs).keys.each do |key|
      job_array << key unless job_array.flatten.include?(key)
    end
    job_array.flatten.reject { |el| el == " " }.join("")
  end
end
