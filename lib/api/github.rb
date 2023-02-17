class Github
  class ResponseError < StandardError
  end
  attr_accessor :username, :token, :owner, :base_url, :issue_base_url, :owner, :repository

  ROOT_URL = 'https://api.github.com'

  def self.raise_http_error(response)
    raise ResponseError.new(JSON.parse(response.body)) unless response.success?
  end

  def initialize
    @token = ENV['GITHUB_PERSONAL_ACCESS_TOKEN']
    @owner = ENV['OWNER']
    @repository = local_repository
    @base_url = ROOT_URL + "/repos/#{ENV['OWNER']}/#{@repository}"
    @issue_base_url = ROOT_URL + "/repos/#{ENV['OWNER']}/#{ENV['OWNER']}"
    @username = current_user_login
  end

  def headers
    { Authorization: "Bearer #{@token}" }
  end

  private

  def current_user_login
    @response = HTTParty.get(ROOT_URL + '/user', headers: self.headers)
    JSON.parse(@response.body)["login"]
  end

  def local_repository
    %x(basename $(git remote get-url origin) .git).chomp
  end
end
