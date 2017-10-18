require 'resque'
require 'resque/server'
require 'json'
require './jobs/lambda'
require 'awesome_print'

# Hook into Resque server, create a new /api-json/info endpoint

module Resque
  module InfoServer

    def self.registered(app)
      app.get '/json-api/info' do
        content_type :json
        Resque.info.to_json
      end

      app.get '/run' do
        Resque.redis = ENV['REDIS_DB']

        beginBatch   = Time.now.to_f

        # Each job takes about 2 seconds to complete
        jobInterval  = 0.5
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

        "Batch Completed in: #{endBatch - beginBatch} seconds."
      end

      app.tabs << "Run"
      app.tabs << "json-api/info"
    end
    
  end
end

Resque::Server.register Resque::InfoServer