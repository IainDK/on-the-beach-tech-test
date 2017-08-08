class JobProcessor

  def initialize(jobs)
    @jobs = jobs
  end

  def ordered_jobs
    fail "A job can't depend on itself." if job_depends_on_itself?
    fail "Jobs can't have circular dependencies." if job_has_circular_dependencies?
    order_jobs.join
  end

  private

  def job_parser
    @jobs.split(",").map { |job| job.lstrip }
  end

  def job_hash
    all_jobs = {}
    job_parser.each do |job|
      all_jobs[job[0]] = job[-1]
    end
    all_jobs
  end

  def order_jobs
    job_array = job_hash.keys
    job_hash.each do |job, dependency|
      if job_array.include?(dependency)
        job_index = job_array.index(job)
        job_array.insert(job_index, dependency)        # Insert the dependency at its job index e.g. ("a => b") > [b, a]
      end
    end
    job_array.uniq
  end

  def job_depends_on_itself?
    self_dependent = false
    job_hash.each do |job, dependency|
      self_dependent = true if job == dependency
    end
    self_dependent
  end

  def job_has_circular_dependencies?
    circular_dependencies = false
    job_hash.each do |job, dependency|
      unless dependency == " "
        circular_dependencies = true if order_jobs.index(dependency) > order_jobs.index(job)
      end
    end
    circular_dependencies
  end
end
