module RepositoriesHelper
  def repository_url(repository)
    "git@#{@host}:#{repository.name_on_disk}"
  end

  def permission_display_name(name)
    case name
    when 'r'
      'Read'
    when 'w'
      'Read/Write'
    when 'f'
      'Full'
    else
      'None'
    end
  end
end
