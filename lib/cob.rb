# !/usr/bin/env ruby
# frozen_string_literal: true

#
# _________  ________ __________
# \_   ___ \ \_____  \\______   \
# /    \  \/  /   |   \|    |  _/
# \     \____/    |    \    |   \
#  \______  /\_______  /______  /
#         \/         \/       \/
#
# The ULTIMATE "cob" tool with a total of 3 distinct usages.
# examples:
#   $ cob                                                     # queries github and gives you a list of issues to pick from
#   $ cob 2837                                                # queries github and checks out the matching issue using "cob" style formating
#   $ cob "my string with #hashes and, other: . punctuations" # instant cob
#   $ cob some sentence without special characters            # instant cob
#

require_relative './git.rb'
require_relative './local_cob.rb'
require_relative './string_refinements.rb'

using StringRefinements

module Cob
  class << self
    def run(args)
      @args = args

      if (@args.length == 1 && !@args[0].all_digits?) || @args.length > 1
        run_local
        exit 0
      end

      run_remote
    rescue Interrupt
      exit 1
    end

    private

    def run_local
      LocalCOB.run
    end

    def run_remote
      require 'json'
      require 'fileutils'
      require 'tty-prompt'
      require_relative './credentials.rb'
      require_relative './paginator.rb'
      require_relative './navigator.rb'
      require_relative './remote_cob.rb'

      RemoteCOB::Selection.run && exit(0) if @args.empty?
      RemoteCOB::Fire.run      && exit(0) if @args.length == 1
    rescue Interrupt
      exit 1
    end
  end
end
