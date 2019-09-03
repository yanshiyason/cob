# frozen_string_literal: true

#
#  ___               _          ___ ___  ___
# | _ \___ _ __  ___| |_ ___   / __/ _ \| _ )
# |   / -_) '  \/ _ \  _/ -_) | (_| (_) | _ \
# |_|_\___|_|_|_\___/\__\___|  \___\___/|___/
#
#
# this module contain the remote commands
module RemoteCOB
  def self.ensure_credentials_and_remote
    Credentials.new.ensure_config_file_is_created

    unless Git.remote
      puts 'could not find remote git repository'
      exit 1
    end

    unless Git.repository_owner && Git.repository
      puts "couldn't retreive repo and owner from remote: #{remote}"
      exit 1
    end
  end

  # This is the code for querying github issues and displaying
  # a select prompt to the user
  module Selection
    def self.run
      RemoteCOB.ensure_credentials_and_remote
      paginator = Paginator.new(Credentials.new)
      issue = Navigator.new(paginator).prompt_for_issue_selection
      Git.checkout_branch(issue)
    end
  end

  # This is the code for automatically checking out the matching issue in github
  module Fire
    def self.run
      RemoteCOB.ensure_credentials_and_remote
      issue_number = ARGV[0].to_i
      paginator = Paginator.new(Credentials.new)

      while paginator.next?
        issue = paginator.issues.detect { |i| i['number'] == issue_number }

        if issue
          Git.checkout_branch(paginator.format_issue(issue))
          exit 0
        end

        puts "couldn't find issue on page: #{paginator.page}, fetching next..."

        paginator.inc
      end

      puts "couldn't find issue on github."
      exit 1
    end
  end
end
