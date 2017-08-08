require 'job_processor'

describe JobProcessor do

  describe 'ordered_jobs' do

    it 'returns an empty string when passed an empty string (no jobs)' do
      job_processor = JobProcessor.new("")
      expect(job_processor.ordered_jobs).to eq ""
    end

    it 'returns a single job when passed a single job (a)' do
      job_processor = JobProcessor.new("a => ")
      expect(job_processor.ordered_jobs).to eq "a"
    end

    it 'returns all jobs in any order when given multiple jobs without dependencies (abc)' do
      job_processor = JobProcessor.new("a => , b => , c => ")
      expect(job_processor.ordered_jobs).to eq "abc"
    end

    it 'returns a single job with a dependency in order' do
      job_processor = JobProcessor.new("a => , b => c, c => ")
      expect(job_processor.ordered_jobs).to eq "acb"
    end

    it 'returns a single job with a dependency in order - 2' do
      job_processor = JobProcessor.new("a => b, b => , c => ")
      expect(job_processor.ordered_jobs).to eq "bac"
    end

    it 'returns a single job with a dependency in order - 3' do
      job_processor = JobProcessor.new("a => , b => , c => a")
      expect(job_processor.ordered_jobs).to eq "abc"
    end

    it 'returns a list of jobs with multiple dependencies in order' do
      job_processor = JobProcessor.new("a => , b => c, c => f, d => a, e => b, f => ")
      expect(job_processor.ordered_jobs).to eq "afcbde"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 2)' do
      job_processor = JobProcessor.new("a => b, b => c, c => f, d => a, e => , f => ")
      expect(job_processor.ordered_jobs).to eq "fcbade"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 3)' do
      job_processor = JobProcessor.new("a => f, b => e, c => a, d => , e => d, f => ")
      expect(job_processor.ordered_jobs).to eq "fadebc"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 4)' do
      job_processor = JobProcessor.new("a => , b => , c => a, d => f, e => b, f => e")
      expect(job_processor.ordered_jobs).to eq "abcefd"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 5)' do
      job_processor = JobProcessor.new("a => d, b => , c => f, d => , e => , f => e")
      expect(job_processor.ordered_jobs).to eq "dabefc"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 6)' do
      job_processor = JobProcessor.new("a => , b => , c => a, d => c, e => , f => ")
      expect(job_processor.ordered_jobs).to eq "abcdef"
    end

    it 'returns a list of jobs with 5 dependencies in order' do
      job_processor = JobProcessor.new("a => b, b => c, c => d, d => e, e => f, f => ")
      expect(job_processor.ordered_jobs).to eq "fedcba"
    end

    it 'returns a list of jobs with 5 dependencies in order (different combination: 2)' do
      job_processor = JobProcessor.new("a => , b => a, c => d, d => b, e => c, f => e")
      expect(job_processor.ordered_jobs).to eq "abdcef"
    end

    it 'returns a list of jobs with 5 dependencies in order (different combination: 3)' do
      job_processor = JobProcessor.new("a => d, b => a, c => , d => e, e => c, f => e")
      expect(job_processor.ordered_jobs).to eq "cedabf"
    end

    it 'works when passed a list of jobs that has 5 dependencies' do
      job_processor = JobProcessor.new("a => b, b => c, c => d, d => e, e => f, f => ")
      expect(job_processor.ordered_jobs).to eq "fedcba"
    end

    it 'returns an error when passed a job that depends on itself e.g. (c => c)' do
      job_processor = JobProcessor.new("a => , b => , c => c")
      expect { job_processor.ordered_jobs }.to raise_error "A job can't depend on itself."
    end

    it 'returns an error when passed a job that depends on itself (different combination: 2))' do
      job_processor = JobProcessor.new("a => , b => a, c => , d => e, e => , f => f")
      expect { job_processor.ordered_jobs }.to raise_error "A job can't depend on itself."
    end

    it 'returns an error when passed a job that has circular dependencies' do
      job_processor = JobProcessor.new("a => , b => c, c => f, d => a, e => , f => b")
      expect { job_processor.ordered_jobs }.to raise_error "Jobs can't have circular dependencies."
    end

    it 'returns an error when passed a job that has circular dependencies (different combination: 2)' do
      job_processor = JobProcessor.new("a => b, b => a")
      expect { job_processor.ordered_jobs }.to raise_error "Jobs can't have circular dependencies."
    end

    it 'returns an error when passed a job that has circular dependencies (different combination: 3)' do
      job_processor = JobProcessor.new("a => b, b => c, c => a")
      expect { job_processor.ordered_jobs }.to raise_error "Jobs can't have circular dependencies."
    end

    it 'returns an error when passed a job that has circular dependencies (different combination: 4)' do
      job_processor = JobProcessor.new("a => b, b => d, c => a, d => a, e => f, f=> ")
      expect { job_processor.ordered_jobs }.to raise_error "Jobs can't have circular dependencies."
    end
  end
end
