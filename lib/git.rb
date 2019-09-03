# frozen_string_literal: true

# this class interfaces with the local `git` command
module Git
  class << self
    def remote
      `git config --list | grep remote.origin.url`&.strip&.split(':')&.last
    end

    def repository
      remote.split('/').last.chomp('.git')
    end

    def repository_owner
      remote.split('/').first
    end

    def checkout_branch(text)
      branch = text.downcase.gsub(/[^a-zA-Z0-9#]+/, '_')
      `git checkout -b #{branch}`
    end
  end
end
