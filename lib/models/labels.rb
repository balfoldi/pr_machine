class Labels
  def initialize
    @api = Github.new
    @name = Branchs.new.tag
  end

  def attach(issue)
    HTTParty.post(path(issue), headers: @api.headers, body: body.to_json)
  end

  private

  def path(issue)
    @api.base_url + "/issues/#{issue.number}/labels"
  end

  def body
    { labels: [@name] }
  end
end
