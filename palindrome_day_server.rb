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
    "<p><i><a href='/'>palindromeday.com</a> written by <a href='http://www.patmaddox.com'>Pat Maddox</a></p>"
  end

  def page(location, date, content_array)
    [
      "<html>",
      "<head>",
      "<title>Palindrome Day #{location} - next one on #{humanize date}</title>",
      "<script src='/wakkawakka.js'/>",
      "</head>",
      "<body>",
      content_array,
      footer,
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
      "<p>",
      "<form method='get' action='/#{location}'>",
      "Look up Palindrome Day in ",
      "<input name='year' size=4 value='#{year}' onclick=\"clickclear(this, '#{year}')\" onblur=\"clickrecall(this, '#{year}')\"/>",
      "<input type='submit'/>",
      "</form>",
      "</p>"
    ]
  end
end

get '/' do
  if params[:year]
    redirect "/#{params[:year]}"
  else
    date = PalindromeDay.next
    page("USA", date, [
      "<h1>Next Palindrome Day in the United States</h1>",
      "<h2>#{humanize date} (#{numbers_america date})</h2>",
      year_form,
      "<p>Do you live in <a href='/europe'>Europe</a>?"
    ])
  end
end

get '/europe' do
  if params[:year]
    redirect "/europe/#{params[:year]}"
  else
    date = PalindromeDay.next_europe
    page("Europe", date, [
      "<h1>Next Palindrome Day in Europe</h1>",
      "<h2>#{humanize date} (#{numbers_europe date})</h2>",
      year_form('europe'),
      "<p>Do you live in the <a href='/'>United States</a>?"
    ])
  end
end

get '/:year' do
  date = PalindromeDay.next(Date.parse("01/01/#{params[:year]}"))
  page("USA", date, [
    "<h1>Palindrome Day in the United States in #{params[:year]}",
    "<h2>#{wait_message params[:year], date} #{humanize date} (#{numbers_america date})</h2>",
    year_form,
    "<p>Do you live in <a href='/europe/#{params[:year]}'>Europe</a>?"
  ])
end

get '/europe/:year' do
  date = PalindromeDay.next_europe(Date.parse("01/01/#{params[:year]}"))
  page("Europe", date, [
    "<h1>Palindrome Day in Europe #{params[:year]}",
    "<h2>#{wait_message params[:year], date} #{humanize date} (#{numbers_europe date})</h2>",
    year_form('europe'),
    "<p>Do you live in the <a href='/#{params[:year]}'>United States</a>?"
  ])
end