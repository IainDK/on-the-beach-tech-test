require 'job_processor'

describe JobProcessor do

  describe 'order_jobs(jobs)' do

    it 'returns an empty string when passed an empty string (no jobs)' do
      expect(subject.order_jobs("")).to eq ""
    end

    it 'returns a single job when passed a single job (a)' do
      expect(subject.order_jobs("a => ")).to eq "a"
    end

    it 'returns all jobs in any order when given multiple jobs without dependencies (abc)' do
      expect(subject.order_jobs("a => , b => , c => ")).to eq "abc"
    end

    it 'returns a single job with a dependency in order' do
      expect(subject.order_jobs("a => , b => c, c => ")).to eq "acb"
    end

    it 'returns a single job with a dependency in order - 2' do
      expect(subject.order_jobs("a => b, b => , c => ")).to eq "bac"
    end

    it 'returns a single job with a dependency in order - 3' do
      expect(subject.order_jobs("a => , b => , c => a")).to eq "abc"
    end

    it 'returns a list of jobs with multiple dependencies in order' do
      expect(subject.order_jobs("a => ,
                                 b => c,
                                 c => f,
                                 d => a,
                                 e => b,
                                 f => ")).to eq "afcbde"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 2)' do
      expect(subject.order_jobs("a => b,
                                 b => c,
                                 c => f,
                                 d => a,
                                 e => ,
                                 f => ")).to eq "fcbade"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 3)' do
      expect(subject.order_jobs("a => f,
                                 b => e,
                                 c => a,
                                 d => ,
                                 e => d,
                                 f => ")).to eq "fadebc"
    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 4)' do
      expect(subject.order_jobs("a => ,
                                 b => ,
                                 c => a,
                                 d => f,
                                 e => b,
                                 f => e")).to eq "abcefd"

    end

    it 'returns a list of jobs with multiple dependencies in order (testing different combinations: 5)' do
      expect(subject.order_jobs("a => d,
                                 b => ,
                                 c => f,
                                 d => ,
                                 e => ,
                                 f => e")).to eq "dabefc"

    end
  end
end
