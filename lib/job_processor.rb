class JobProcessor

  def initialize(jobs)
    @jobs = jobs
    @ordered_jobs = []
  end

  def return_ordered_jobs
    fail "A job can't depend on itself." if job_depends_on_itself?
    fail "Jobs can't have circular dependencies." if job_has_circular_dependencies?
    organise_jobs.join("")
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

  def push_jobs_without_dependencies
    job_hash.each { |job, dependency| @ordered_jobs << job if dependency == " "}
  end

  def push_jobs_with_singular_dependencies
    job_hash.each { |job, dependency| @ordered_jobs << job if @ordered_jobs.include?(dependency)}
  end

  def push_jobs_with_nested_dependencies
    job_hash.each do |job, dependency|
      unless @ordered_jobs.include?(job)
        @ordered_jobs.include?(dependency) ? @ordered_jobs << job : @ordered_jobs << dependency << job
      end
    end
  end

  def organise_jobs
    delete_job_entries unless @ordered_jobs.empty?
    push_jobs_without_dependencies
    push_jobs_with_singular_dependencies
    push_jobs_with_nested_dependencies
    @ordered_jobs
  end

  def delete_job_entries
    @ordered_jobs.clear
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
        circular_dependencies = true if organise_jobs.index(dependency) > organise_jobs.index(job)
      end
    end
    circular_dependencies
  end
end
