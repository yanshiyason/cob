# frozen_string_literal: true

module StringRefinements
  refine String do
    def all_digits?
      scan(/\D/).empty?
    end
  end
end
