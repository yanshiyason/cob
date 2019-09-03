# frozen_string_literal: true

#  _                 _    ___ ___  ___
# | |   ___  __ __ _| |  / __/ _ \| _ )
# | |__/ _ \/ _/ _` | | | (_| (_) | _ \
# |____\___/\__\__,_|_|  \___\___/|___/
#
#
# This is the original COB
#
module LocalCOB
  def self.run
    Git.checkout_branch(ARGV.join(' '))
  end
end
