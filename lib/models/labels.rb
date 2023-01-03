class Labels
  def initialize(name: nil)
    @api = Github.new
    @name = name || Branchs.new.tag
  end

  def attach(issue_number)
    HTTParty.post(path(issue_number), headers: @api.headers, body: body.to_json)
  end

  private

  def path(issue_number)
    @api.base_url + "/issues/#{issue_number.number}/labels"
  end

  def body
    { labels: [@name] }
  end
end
