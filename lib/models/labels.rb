class Labels
  def initialize(name: nil)
    @api = Github.new
    @name = name || Branchs.new.tag
  end

  def attach(object_with_number)
    HTTParty.post(path(object_with_number), headers: @api.headers, body: body.to_json)
  end

  private

  def path(object_with_number)
    return @api.issue_base_url + "/issues/#{object_with_number[:issue_number]}/labels" if object_with_number[:issue_number]
    return @api.base_url + "/issues/#{object_with_number[:pull_request_number]}/labels" if object_with_number[:pull_request_number]
  end

  def body
    { labels: [@name] }
  end
end
