# frozen_string_literal: true

# this class fetches and paginates the issues from github.com
class Paginator
  attr_reader :page

  def initialize(credentials)
    @credentials = credentials
    @page = 1
    @cache = {}
    @next = {}
  end

  def issues
    @cache[@page] ||= begin
      issues = fetch_issues
      @next[@page] = issues.count.positive?
      issues
    end
  end

  def no_issues?
    @page == 1 && issues.empty?
  end

  def next?
    issues && @next[@page]
  end

  def prev?
    @page > 1
  end

  def format_issue(issue)
    "#{issue['number']} --- #{issue['title']}"
  end

  def formatted_issues
    issues.map { |i| format_issue(i) }
  end

  def dec
    @page = [@page - 1, 1].max
  end

  def inc
    @page += 1
  end

  private

  def fetch_issues
    _header, body = http_get_issues.split("\r\n\r\n")
    data = JSON.parse(body)

    # TODO: move elsewhere
    if data.is_a?(Hash) && data['message'] == 'Bad credentials'
      puts 'Your github credentials are wrong.'

      @credentials.reset_config_file
      exit 1
    end

    data.select { |i| i['pull_request'].nil? } # ignore pull requests
  end

  def http_get_issues
    uname = @credentials.username
    token = @credentials.pa_token
    `curl -sS -i https://api.github.com/repos/#{Git.repository_owner}/#{Git.repository}/issues?page=#{@page} \
          -u "#{uname}:#{token}" \
          -H "Content-Type: application/json"`
  end
end
