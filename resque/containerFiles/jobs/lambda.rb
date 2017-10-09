require 'net/http'
require 'awesome_print'

class Lambda
  def self.before_perform_log()
    # At this point, puts or ap will write out to workers.log
    
  end

  def self.after_perform_log()
    
  end
	
  def self.queue
    :lambda
  end

  def self.perform()
    begin
      tries ||= 5
      response = Net::HTTP.get(URI('http://piarmy_lambda'))
    rescue Errno::ECONNREFUSED => e
      if (tries -= 1) > 0
        retry
      else
        ap "Errno::ECONNREFUSED: Could not connect after 5 tries."
      end
    end
  end
end

