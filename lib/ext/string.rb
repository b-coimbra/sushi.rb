# typed: true
# frozen_string_literal: true

# String extension
class String
  def blank?
    self[/^\s+$/] || empty?
  end

  def to_regex
    /#{Regexp.quote(self)}/
  end
end
