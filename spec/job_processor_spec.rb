require 'job_processor'

describe JobProcessor do

  describe 'return_ordered_jobs(jobs)' do

    it 'returns an empty string when passed an empty string (no jobs)' do
      job_processor = JobProcessor.new("")
      expect(job_processor.return_ordered_jobs).to eq ""
    end

    it 'returns a single job when passed a single job (a)' do
      job_processor = JobProcessor.new("a => ")
      expect(job_processor.return_ordered_jobs).to eq "a"
    end

    it 'returns all jobs in any order when given multiple jobs without dependencies (abc)' do
      job_processor = JobProcessor.new("a => , b => , c => ")
      expect(job_processor.return_ordered_jobs).to eq "abc"
    end

    it 'returns a single job with a dependency in order' do
      job_processor = JobProcessor.new("a => , b => c, c => ")
      expect(job_processor.return_ordered_jobs).to eq "acb"
    end

    it 'returns a single job with a dependency in order - 2' do
      job_processor = JobProcessor.new("a => b, b => , c => ")
      expect(job_processor.return_ordered_jobs).to eq "bca"
    end

    it 'returns a single job with a dependency in order - 3' do
      job_processor = JobProcessor.new("a => , b => , c => a")
      expect(job_processor.return_ordered_jobs).to eq "abc"
    end

    it 'returns a list of jobs with multiple dependencies in order' do
      job_processor = JobProcessor.new("a => , b => c, c => f, d => a, e => b, f => ")
      expect(job_processor.return_ordered_jobs).to eq "afcdbe"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 2)' do
      job_processor = JobProcessor.new("a => b, b => c, c => f, d => a, e => , f => ")
      expect(job_processor.return_ordered_jobs).to eq "efcbad"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 3)' do
      job_processor = JobProcessor.new("a => f, b => e, c => a, d => , e => d, f => ")
      expect(job_processor.return_ordered_jobs).to eq "dfaceb"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 4)' do
      job_processor = JobProcessor.new("a => , b => , c => a, d => f, e => b, f => e")
      expect(job_processor.return_ordered_jobs).to eq "abcefd"

    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 5)' do
      job_processor = JobProcessor.new("a => d, b => , c => f, d => , e => , f => e")
      expect(job_processor.return_ordered_jobs).to eq "bdeafc"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 6)' do
      job_processor = JobProcessor.new("a => , b => , c => a, d => c, e => , f => ")
      expect(job_processor.return_ordered_jobs).to eq "abefcd"
    end
  end
end
