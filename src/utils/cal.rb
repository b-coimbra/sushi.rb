require 'date'
def cal(offset, month_length)
  month      = Time.now.strftime("%m").to_i
  day        = Time.now.strftime("%d").to_i
  days       = "Mon  Tue Wed Thu Fr Sat Sun"
  month_date = "#{Date::MONTHNAMES[month]}, #{month}"
  title      = "#{month_date}#{days}"

  puts month_date.rjust(title.length / 2).red
  [*1..month_length].unshift(*Array.new(offset)).
    each_slice(7).map { |week|
      week.map { |date| "%3s" % [(date == day ? " " + date.to_s.bg_red : date)] }.join " "
    }.unshift(days)
end