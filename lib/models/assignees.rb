class Assignees
  def initialize
    @api = Github.new
    @username = @api.username
    @owner = @api.owner
    @repository = local_repository
  end

  def attach(issue)
    HTTParty.post(path(issue), headers: @api.headers, body: body.to_json)
  end

  private

  def path(issue)
    Github::BASE_URL + "/#{@owner}/#{@repository}/issues/#{issue.number}/assignees"
  end

  def body
    { assignees: [@username] }
  end

  def local_repository
    %x(basename `git rev-parse --show-toplevel`).chomp
  end
end
