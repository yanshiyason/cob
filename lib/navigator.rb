# frozen_string_literal: true

# this class prompts the user for selection and shows "next..." and "prev..."
# when the user can navigate to the next/prev pages.
class Navigator
  def initialize(paginator)
    @paginator = paginator
    @active_index = 1
  end

  def prompt_for_issue_selection
    prompt = TTY::Prompt.new(active_color: :cyan)

    if @paginator.no_issues?
      puts 'No issues found.'
      exit 0
    end

    @selected_index = prompt.select('Select issue:') do |menu|
      menu.default @active_index

      items.each.with_index(1) do |item, i|
        menu.choice item.to_s, i
      end
    end

    handle_selection
  end

  def items
    ii = @paginator.formatted_issues
    ii = ['prev...'] + ii if show_prev?
    ii += ['next...'] if show_next?
    ii
  end

  private

  def show_prev?
    @paginator.prev?
  end

  def show_next?
    @paginator.next?
  end

  def handle_selection
    choice = items[@selected_index - 1]

    return choice unless ['next...', 'prev...'].include? choice

    if choice == 'next...'
      @paginator.inc
      @active_index = 1
    end

    if choice == 'prev...'
      @paginator.dec
      @active_index = [items.count, 1].max
    end

    prompt_for_issue_selection
  end
end
