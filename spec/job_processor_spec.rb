require 'job_processor'

describe JobProcessor do

  describe 'order_jobs' do

    it 'returns an empty string when passed an empty string (no jobs)' do
      expect(subject.order_jobs("")).to eq ""
    end
  end
end
