
require "bundler"
require "json"
Bundler.require
Dotenv.load("#{__dir__}/.env")

require_relative "./lib/api/github.rb"
require_relative "./lib/models/labels.rb"
require_relative "./lib/models/assignees.rb"
require_relative "./lib/models/pull_requests.rb"
require_relative "./lib/models/branchs.rb"

p "My owner is #{ENV['OWNER']}}"

unless ARGV[0]
  p 'Send() me anything to my PullRequests class'
  input = gets.chomp
else
  input = ARGV[0]
  p "Ok, i will send() #{ARGV[0]}"
end

p PullRequests.new.send(input)
