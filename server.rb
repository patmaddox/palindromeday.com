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
end

get '/' do
  date = PalindromeDay.next
  parts = [
    "<h1>Next Palindrome Day in the United States</h1>",
    "<h2>#{humanize date} (#{numbers_america date})</h2>",
    "<p>Do you live in <a href='/europe'>Europe</a>?"
  ]
  parts.join "\n"
end

get '/europe' do
  date = PalindromeDay.next_europe
  parts = [
    "<h1>Next Palindrome Day in Europe</h1>",
    "<h2>#{humanize date} (#{numbers_europe date})</h2>",
    "<p>Do you live in the <a href='/'>United States</a>?"
  ]
  parts.join "\n"
end