
require "bundler"
require "json"
Bundler.require
Dotenv.load("#{__dir__}/.env")

require_relative "./lib/api/github.rb"
require_relative "./lib/models/labels.rb"
require_relative "./lib/models/assignees.rb"
require_relative "./lib/models/pull_requests.rb"
require_relative "./lib/models/branchs.rb"

p PullRequests.new.base_branch
