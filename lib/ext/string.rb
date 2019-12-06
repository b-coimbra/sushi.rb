class String
  def blank?
    self[/^\s+$/] || self.empty?
  end

  def to_regex
    /#{Regexp.quote(self)}/
  end
end
