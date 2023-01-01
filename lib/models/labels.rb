require_relative "../api/github.rb"

class Labels
  def initialize(name:)
    @api = Github.new
    @name = name
    @owner = @api.owner
    @repository = local_repository

  end

  def attach(issue)
    HTTParty.post(path(issue), headers: @api.headers, body: body.to_json)
  end

  private

  def path(issue)
    Github::BASE_URL + "/#{@owner}/#{@repository}/issues/#{issue.number}/labels"
  end

  def body
    { labels: [@name] }
  end

  def local_repository
    %x(basename `git rev-parse --show-toplevel`).chomp
  end
end
