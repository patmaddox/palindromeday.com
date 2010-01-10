require 'sinatra'
require 'palindrome_day'

helpers do
  def humanize(date)
    date.strftime '%A %B %d, %Y'
  end

  def numbers_america(date)
    date.strftime '%m-%d-%Y'
  end

  def numbers_europe(date)
    date.strftime '%d-%m-%Y'
  end

  def footer
    "<p><i>Written by <a href='http://www.patmaddox.com'>Pat Maddox</a></p>"
  end

  def page(location, date, content_array)
    [
      "<html>",
      "<head><title>Palindrome Day #{location} - next on #{humanize date}</title></head>",
      "<body>",
      content_array,
      footer,
      "</body>",
      "</html>"
    ].flatten.join "\n"
  end
end

get '/' do
  date = PalindromeDay.next
  page("USA", date, [
    "<h1>Next Palindrome Day in the United States</h1>",
    "<h2>#{humanize date} (#{numbers_america date})</h2>",
    "<p>Do you live in <a href='/europe'>Europe</a>?"
  ])
end

get '/europe' do
  date = PalindromeDay.next_europe
  page("Europe", date, [
    "<h1>Next Palindrome Day in Europe</h1>",
    "<h2>#{humanize date} (#{numbers_europe date})</h2>",
    "<p>Do you live in the <a href='/'>United States</a>?"
  ])
end