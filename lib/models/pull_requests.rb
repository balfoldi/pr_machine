class PullRequests
  attr_accessor :number, :owner, :template
  BASE_BRANCH_NAME = ENV['BASE_BRANCH']

  def initialize(number: nil)
    @api = Github.new
    @number = number

    @title = default_title
    @template = local_template
    @current_branch = Branchs.new
    @base_branch_name = base_branch_name
    @base_label = Labels.new
  end

  def post
    @current_branch.publish

    response = HTTParty.post(path, headers: @api.headers, body: body.to_json)

    @number = JSON.parse(response.body)["number"]

    Labels.new.attach self
    Assignees.new.attach self
  end

  def get
    HTTParty.get(path, headers: @api.headers)
  end

  private

  def base_branch_name
    response = HTTParty.get(@api.base_url, headers: @api.headers)

    JSON.parse(response.body)["default_branch"]
  end

  def path
    path = @api.base_url + "/pulls"
    path + "/#{@number}" if @number

    path
  end

  def body
    { title: @title, body: @template, head: @current_branch.name, base: @base_branch_name }
  end

  def current_branch
    %x(git rev-parse --abbrev-ref HEAD).chomp
  end

  def default_title
    current_branch.capitalize.gsub('_', ' ')
  end

  def local_template
    File.read('.github/PULL_REQUEST_TEMPLATE.md') if File.exists?('.github/PULL_REQUEST_TEMPLATE.md')
  end
end
