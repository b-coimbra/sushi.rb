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

def rb_exec(*cmds)
  cmds = cmds*?\s
  if !blank?(cmds)
    begin
      return eval cmds. \
        gsub(/\[/,"("). \
        gsub(/\]/,")"). \
        gsub(/(modulus|mod)/i,"%"). \
        gsub(/(subtract|minus)/i,"-"). \
        gsub(/(add|plus)/i,"+"). \
        gsub(/(\^|power by)/i,"**"). \
        gsub(/(divided by|÷)/i,"/"). \
        gsub(/(×|∙|multiplied by)/i,"*"). \
        gsub(/try/im, 'begin'). \
        gsub(/finally/im, 'ensure'). \
        gsub(/while True/im, 'loop do'). \
        gsub(/except\s(.*)/im, 'rescue \1'). \
        gsub(/import\s(\w+)/im, "require '\\1'"). \
        gsub(/for\s(.*)\sin\s(.*)\:\n\s(.*)/im, '\2.map { |\1| \3 }'). \
        gsub(/([if|else|elif|def|while|with|class|for]+\s.*?)\:(.*)/im, '\1; \2 end'). \
        gsub(/(if)\s__name__\s==\s'__main__'/im, '\1 __FILE__ == $0')
    rescue ScriptError => e
      print e
    end
  else
    puts "example: > puts 'hello'.red"
  end
end