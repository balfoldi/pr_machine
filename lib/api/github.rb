class Github
  attr_accessor :username, :token, :owner, :base_url

  ROOT_URL = 'https://api.github.com'

  def initialize
    @token = ENV['GITHUB_PERSONAL_ACCESS_TOKEN']
    @base_url = ROOT_URL + "/#{ENV['OWNER']}/#{local_repository}"
    @username = current_user_login
  end

  def headers
    { Authorization: "Bearer #{@token}" }
  end

  private

  def current_user_login
    response = HTTParty.get(ROOT_URL + '/user', headers: self.headers)
    JSON.parse(response.body)["login"]
  end

  def local_repository
    %x(basename `git rev-parse --show-toplevel`).chomp
  end
end
