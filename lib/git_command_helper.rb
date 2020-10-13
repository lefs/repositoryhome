# Various methods to help with git command parsing.
module GitCommandHelper
  # Below are the git commands this module knows about.
  READ_COMMANDS = [
    'git-receive-pack', 'git receive-pack'
  ]
  WRITE_COMMANDS = [
    'git-upload-pack', 'git upload-pack',
    'git-upload-archive', 'git upload-archive'
  ]
  VALID_COMMANDS = READ_COMMANDS + WRITE_COMMANDS

  class GitCommandError < StandardError; end

  # Returns an array where [0] is the git command and [1] is the argument.
  # Possible errors when parsing a command:
  #  * Command contains newline.
  #  * Command is bad (more than 2 arguments).
  #  * Command is unknown.
  def self.parse_command(cmd)
    raise GitCommandError, 'Command can not be nil' if cmd == nil
    # Command can't include a newline.
    raise GitCommandError, 'Command includes a newline.' if cmd.include? '\n'

    # Let's split the command in parts.
    parts = cmd.split(' ')
    unless parts.length == 2 || parts.length == 3
      raise GitCommandError, 'Command has the wrong number of arguments.'
    end

    if parts.length == 3
      # The first two parts are the command part.
      parts = ["#{parts[0]} #{parts[1]}", parts[2]]
    end
    # The command argument comes wrapped in quotes. We need to strip
    # them in order to use it here and we'll add them later on.
    parts[1].gsub!("'", '')

    # Check if the command is valid.
    unless VALID_COMMANDS.include? parts[0]
      raise GitCommandError, 'Uknown command.'
    end

    parts
  end

  def self.command_type(cmd)
    if WRITE_COMMANDS.include? cmd
      :write
    elsif READ_COMMANDS.include? cmd
      :read
    else
      nil
    end
  end
end
