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