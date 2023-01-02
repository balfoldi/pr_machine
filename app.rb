
require "bundler"
require "json"
Bundler.require
Dotenv.load("#{__dir__}/.env")

require_relative "./lib/api/github.rb"
require_relative "./lib/models/labels.rb"
require_relative "./lib/models/assignees.rb"
require_relative "./lib/models/pull_requests.rb"
require_relative "./lib/models/branchs.rb"

pr = PullRequests.new
p pr.post
p pr
# binding.pry
# p Labels.new
