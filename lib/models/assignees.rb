class Assignees
  def initialize
    @api = Github.new
    @username = @api.username
  end

  def attach(issue)
    HTTParty.post(path(issue), headers: @api.headers, body: body.to_json)
  end

  private

  def path(issue)
    @api.base_url + "/issues/#{issue.number}/assignees"
  end

  def body
    { assignees: [@username] }
  end
end
