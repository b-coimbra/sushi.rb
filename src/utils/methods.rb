class String
  define_method(:format) { |*args| self.tr('{}', '%s') % args }
end

module Kernel
  alias_method :__init__, :initialize
  alias_method :import, :require
end

define_method(:input) { |str| print str; gets.to_s }
define_method(:len)   { |obj| obj.length }
define_method(:int)   { |num| num.to_i }
define_method(:str)   { |int| int.to_i }
define_method(:range) { |num| (0..num) }

define_method(:is_windows) { !RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im] }

define_method(:connected?) { return (!!`ping 192.168.1.1`) rescue false }

define_method(:blank?) { |i| i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m] }

define_method(:show_prompt_git?) { has_git? || $Prompt = $dir }

define_method(:handle_error) { |msg='Invalid syntax / argument.'| puts msg.red; show_prompt_git?; Core::new.main }

def spellcheck(a, b)
  longer = [a.size, b.size].max
  same = a.each_char.zip(b.each_char).select { |a,b| a == b }.size
  (longer - same) / a.size.to_f
end

class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KB' => 1024 * 1024,
      'MB' => 1024 * 1024 * 1024,
      'GB' => 1024 * 1024 * 1024 * 1024,
      'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s }
  end
end