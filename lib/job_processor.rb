class JobProcessor

  def initialize(jobs)
    @jobs = jobs
    @ordered_jobs = []
  end

  def return_ordered_jobs
    organise_jobs
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
    push_jobs_without_dependencies
    push_jobs_with_singular_dependencies
    push_jobs_with_nested_dependencies
    @ordered_jobs.join("")
  end
end
