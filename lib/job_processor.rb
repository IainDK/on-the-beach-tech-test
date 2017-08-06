class JobProcessor

  def order_jobs(jobs)
    return "" if jobs.empty?
    ordered_job_array(jobs).join("")
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
    job_array = job_hash(jobs).keys
    job_hash(jobs).each do |name, dependency|
      if job_array.include?(dependency)
        name_index = job_array.index(name)
        job_array.insert(name_index, dependency)
      end
    end
    job_array.uniq
  end
end
