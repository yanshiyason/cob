# frozen_string_literal: true

#
# class to handle the credentials
#
# usage:
#
# c = Credentials.new
# c.username
# c.pa_token
#
class Credentials
  def initialize
    @config_file = ENV['GITHUB_CREDENTIALS_FILE'] ||
                   "#{ENV['HOME']}/.cob/github_credentials.json"
    @config = parse_config
  end

  def username
    # USERNAME
    @config['username'] || prompt_username
  end

  def pa_token
    # PA_TOKEN
    @config['paToken'] || prompt_pa_token
  end

  def overwrite_config
    File.write(@config_file, @config.to_json)
  end

  def prompt_username
    prompt = TTY::Prompt.new(active_color: :cyan)
    username = prompt.ask('What is your github username?') do |q|
      q.required true
      q.modify   :lowercase
    end

    @config['username'] = username
    overwrite_config

    username
  end

  def prompt_pa_token
    prompt = TTY::Prompt.new(active_color: :cyan)
    token = prompt.ask('What is your github personal access token? You can get one from here: https://github.com/settings/tokens') do |q|
      q.required true
    end

    @config['paToken'] = token
    overwrite_config

    token
  end

  def reset_config_file
    File.write(@config_file, '{}')
  end

  def ensure_config_file_is_created
    return if File.exist?(@config_file)

    segments = @config_file.split('/')
    paths    = segments[0..-2]
    file     = segments[-1]
    dir      = paths.join('/')
    FileUtils.mkdir_p(dir)
    FileUtils.touch(dir + '/' + file)

    reset_config_file
  end

  private

  def parse_config
    JSON.parse(File.read(@config_file))
  rescue StandardError => e
    puts "Couldn't parse config file. Make sure the JSON is  correct:\n#{@config_file}"
    raise e
  end
end
