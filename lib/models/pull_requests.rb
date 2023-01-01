require_relative "../api/github.rb"

class PullRequests
  attr_accessor :number, :owner, :template
  BASE_BRANCH = 'develop'
  BASE_NAME = 'Feature'
  BASE_LABEL = Labels.new(name: 'feature')

  def initialize(number: nil)
    @api = Github.new
    @owner = @api.owner
    @repository = local_repository
    @number = number

    @title = default_title
    @template = local_template
    @head_branch = current_branch
    @base_branch = BASE_BRANCH
  end

  def post
    system("git push --set-upstream origin #{@head_branch}")
    response = HTTParty.post(path, headers: @api.headers, body: body.to_json)

    @number = JSON.parse(response.body)["number"]

    BASE_LABEL.attach self
    Assignees.new.attach self
  end

  def get
    HTTParty.get(path, headers: @api.headers)
  end

  private

  def path
    path = Github::BASE_URL + "/#{@owner}/#{@repository}/pulls"
    path + "/#{@number}" if @number

    path
  end

  def body
    { title: @title, body: @template, head: @head_branch, base: @base_branch }
  end

  def local_repository
    %x(basename `git rev-parse --show-toplevel`).chomp
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
