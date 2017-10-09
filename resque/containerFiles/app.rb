require 'resque'
require './jobs/lambda'
require 'awesome_print'

system "clear"

Resque.redis = ENV['REDIS_DB']

beginBatch   = Time.now.to_f

# Each job takes about 3 seconds to complete
jobInterval  = 0.75
numberOfJobs = 100

puts "Running job batch:"

numberOfJobs.times do |count|
  puts "Queuing job [#{Time.now}]: #{count}"
  Resque.enqueue(Lambda)
  sleep jobInterval
end

while Resque.info[:pending] != 0
  completedJobs = numberOfJobs - Resque.info[:pending]
  percentComplete = (completedJobs*100)/numberOfJobs
  print "Progress: #{percentComplete}%\r".green
  $stdout.flush
  sleep 0.5
end

puts ""

endBatch = Time.now.to_f

puts "Batch Completed in: #{endBatch - beginBatch} seconds."