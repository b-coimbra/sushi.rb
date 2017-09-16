# evaluates common mathematical expressions
def calc(expr)
  return eval(expr.gsub(/\[/,"(") \
  .gsub(/\]/,")") \
  .gsub(/(modulus|mod)/i,"%") \
  .gsub(/(subtract|minus)/i,"-") \
  .gsub(/(add|plus)/i,"+") \
  .gsub(/(\^|power by)/i,"**") \
  .gsub(/(×|∙|multiplied by)/i,"*") \
  .gsub(/(divided by|÷)/i,"/") \
  .gsub(/[^0-9\s\-\(\)^*+\/]/,"")) rescue return false
end