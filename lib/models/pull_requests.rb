class PullRequests
  attr_accessor :number, :owner, :template
  BASE_BRANCH_NAME = ENV['BASE_BRANCH']
  ISSUE_URL = 'https://github.com/captaincontrat/captaincontrat/issues/'

  def initialize
    @api = Github.new
    @number = number

    @title = default_title
    @head_branch = Branchs.new
    @base_branch_name = base_branch_name
    @base_label = Labels.new
  end

  def post
    @head_branch.publish
    @head_branch.validate_diff_with!(@base_branch_name)

    response = HTTParty.post(path, headers: @api.headers, body: body.to_json)

    Github.raise_http_error(response)

    @number = JSON.parse(response.body)["number"]

    Labels.new.attach self
    Assignees.new.attach self
  end

  def get
    search_query="repo:#{@api.owner}/#{@api.repository}+head:#{@head_branch.name}"
    url="https://api.github.com/search/issues?q=#{search_query}"

    response = HTTParty.get(url, headers: @api.headers)

    return unless JSON.parse(response.body)["total_count"] > 0

    @number = JSON.parse(response.body)["items"].first["number"]
  end

  def move_to_qa
    get if @number.nil?

    @head_branch.push_to_qa

    Labels.new(name: 'QA').attach @number
    Labels.new(name: 'QA').attach @head_branch.issue_number
  end

  private

  def base_branch_name
    response = HTTParty.get(@api.base_url, headers: @api.headers)

    Github.raise_http_error(response)

    JSON.parse(response.body)["default_branch"]
  end

  def path
    path = @api.base_url + "/pulls"
    path + "/#{@number}" if @number

    path
  end

  def body
    { title: @title, body: local_template, head: @head_branch.name, base: @base_branch_name }
  end

  def head_branch
    %x(git rev-parse --abbrev-ref HEAD).chomp
  end

  def default_title
    head_branch.capitalize.gsub('_', ' ')
  end

  def issue_url
    url = @api.base_url + "/issues/#{@head_branch.issue_number}/"
    response = HTTParty.get(@api.base_url, headers: @api.headers)

    JSON.parse(response.body)
  end

  def local_template
    return unless File.exists?('.github/PULL_REQUEST_TEMPLATE.md')

    template = File.read('.github/PULL_REQUEST_TEMPLATE.md')

    issue_url_checkbox_selector = '- [x]'

    template.gsub(issue_url_checkbox_selector, issue_url_checkbox_selector + ' ' + ISSUE_URL + @head_branch.issue_number) + "\nThis PR was made using https://github.com/balfoldi/yandere_machine"
  end
end
