require 'sinatra'
require 'palindrome_day'

helpers do
  def humanize(date)
    date.strftime '%A %B %d, %Y'
  end

  def month_and_day(date)
    date.strftime '%B %d'
  end

  def numbers_america(date)
    date.strftime '%m-%d-%Y'
  end

  def numbers_europe(date)
    date.strftime '%d-%m-%Y'
  end

  def footer
    "<p><i><a href='/'>palindromeday.com</a> written by <a href='http://www.patmaddox.com'>Pat Maddox</a>" +
    " - <a href='http://github.com/patmaddox/palindromeday.com'>Fork me on github</i></p>"
  end

  def page(location, date, content_array)
    [
      %(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">),
      %(<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">),
      "<head>",
      %(<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>),
      "<title>Palindrome Day #{location} - next one on #{humanize date}</title>",
      "<script src='/jquery-1.3.2.min.js' type='text/javascript'></script>",
      "<script src='/wakkawakka.js' type='text/javascript'></script>",
      "</head>",
      "<body>",
      content_array,
      footer,
      "<input id='year_field' type='hidden' value='#{params[:year] || Date.today.year}'/>",
      "</body>",
      "</html>"
    ].flatten.join "\n"
  end

  def wait_message(given_year, palindrome_day)
    if palindrome_day.year != given_year.to_i
      message = "There is no Palindrome Day in #{given_year} :(<br/>You will have to wait until"
    end    
  end

  def year_form(location='')
    year = params[:year] || Date.today.year
    [
      "<form action='/#{location}'>",
      "Look up Palindrome Day in",
      "<input name='year' size='4' value='#{year}' onclick=\"clickclear(this, '#{year}')\" onblur=\"clickrecall(this, '#{year}')\"/>",
      "<input type='submit'/>",
      "</form>",
    ]
  end

  def birthday_form
    months = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    [
      "<form action='/'>",
      "Look up Palindrome Day on your birthday!",
      "<select name='month' id='month_select' onchange='setDay()'>",
      months.collect {|month| "<option value='#{months.index(month)}'>#{month}</option>" },
      "</select>",
      "<select name='day' id='day_select'>",
      "<option value=' '></option>",
      "</select>",
      "<input type='submit'/>",
      "</form>",
    ]
  end
end

get '/' do
  if params[:year]
    redirect "/#{params[:year]}"
  elsif params[:month] && params[:day]
    redirect "/#{params[:month]}/#{params[:day]}"
  else
    date = PalindromeDay.next
    page("USA", date, [
      "<h1>Next Palindrome Day in the United States</h1>",
      "<h2>#{humanize date} (#{numbers_america date})</h2>",
      year_form,
      birthday_form,
      "<p>Do you live in <a href='/europe'>Europe</a>?</p>"
    ])
  end
end

get '/europe' do
  if params[:year]
    redirect "/europe/#{params[:year]}"
  elsif params[:month] && params[:day]
    redirect "/#{params[:month]}/#{params[:day]}"
  else
    date = PalindromeDay.next_europe
    page("Europe", date, [
      "<h1>Next Palindrome Day in Europe</h1>",
      "<h2>#{humanize date} (#{numbers_europe date})</h2>",
      year_form('europe'),
      birthday_form,
      "<p>Do you live in the <a href='/'>United States</a>?</p>"
    ])
  end
end

get '/:month/:day' do
  date = PalindromeDay.for_day :month => params[:month], :day => params[:day]
  message = if date == Date.today
    "is today!  HAPPY BIRTHDAY!!!!!!!!!"
  elsif date < Date.today
    "was in #{date.year}"
  else
    "will be in #{date.year}"
  end
  page("", date, [
    "<h1>Palindrome Day for #{month_and_day date} #{message}</h1>",
    year_form,
    birthday_form
  ])  
end

get '/:year' do
  date = PalindromeDay.next(Date.parse("01/01/#{params[:year]}"))
  page("USA", date, [
    "<h1>Palindrome Day in the United States in #{params[:year]}",
    "<h2>#{wait_message params[:year], date} #{humanize date} (#{numbers_america date})</h2>",
    year_form,
    birthday_form,
    "<p>Do you live in <a href='/europe/#{params[:year]}'>Europe</a>?</p>"
  ])
end

get '/europe/:year' do
  date = PalindromeDay.next_europe(Date.parse("01/01/#{params[:year]}"))
  page("Europe", date, [
    "<h1>Palindrome Day in Europe #{params[:year]}",
    "<h2>#{wait_message params[:year], date} #{humanize date} (#{numbers_europe date})</h2>",
    year_form('europe'),
    birthday_form,
    "<p>Do you live in the <a href='/#{params[:year]}'>United States</a>?</p>"
  ])
end