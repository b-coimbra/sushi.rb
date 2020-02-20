# typed: true
# frozen_string_literal: true

module OS
  def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def unix?
    !self.windows?
  end

  def linux?
    self.unix? and not self.mac?
  end

  def jruby?
    RUBY_ENGINE == 'jruby'
  end
end

class System
  extend T::Sig
  include OS
end
