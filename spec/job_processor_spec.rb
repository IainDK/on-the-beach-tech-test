require 'job_processor'

describe JobProcessor do

  describe 'order_jobs' do

    it 'returns an empty string when passed an empty string (no jobs)' do
      expect(subject.order_jobs("")).to eq ""
    end

    it 'returns a single job when passed a single job (a)' do
      expect(subject.order_jobs("a =>")).to eq "a"
    end

    it 'returns all jobs in any order when given multiple jobs without dependencies (abc)' do
      expect(subject.order_jobs("a => , b => , c => ")).to eq "abc"
    end
  end
end
