class Branchs
  class BranchNameFormatError < StandardError
  end
  class NoDiffError < StandardError
  end

  VALID_FORMAT_REGEX = /\/\d+_/

  attr_accessor :name, :tag, :issue_number

  def initialize
    @api = Github.new
    @name = current

    validate!

    @tag = @name.split('/', 2)[0]
    @issue_number = @name.match(/\d+/)[0]
  end

  def publish
    system("git push --set-upstream origin #{@name}") unless remote?
  end

  def push_to_qa
    system("git checkout qa")
    system("git pull")
    system("git pull origin #{@name}")
    system("git push")
  end

  def validate!
    return if @name.nil? || @name.match?(VALID_FORMAT_REGEX)

    raise BranchNameFormatError
  end

  private

  def remote?
    !%x("git ls-remote origin #{@name}").empty?
  end

  def split_name
    @tag = @name.split('/')
  end

  def current
    %x(git rev-parse --abbrev-ref HEAD).chomp
  end

  def validate_diff_with_base_branch
    return unless %x(git diff #{@head_branch.name} #{@base_branch_name}).empty?

    raise NoDiffError
  end
end
