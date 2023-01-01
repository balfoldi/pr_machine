class Github
  attr_accessor :username, :token, :owner

  BASE_URL = 'https://api.github.com/repos'

  def initialize
    @username = ENV['GITHUB_USERNAME']
    @token = ENV['GITHUB_PERSONAL_ACCESS_TOKEN']
    @owner = ENV['OWNER']
  end

  def headers
    { Authorization: "Bearer #{@token}" }
  end
end
