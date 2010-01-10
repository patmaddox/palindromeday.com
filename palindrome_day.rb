class PalindromeDay
  def self.in_year(year)
    America.new(year).to_date
  end

  def self.europe(year)
    Europe.new(year).to_date
  end

  def self.next(date = Date.today)
    find_next :in_year, date
  end

  def self.next_europe(date = Date.today)
    find_next :europe, date
  end

  private

  def self.find_next(finder, start_date)
    this_year = Date.today.year
    while (palindrome_day = send(finder, this_year)).nil? || palindrome_day < start_date
      this_year += 1
    end
    palindrome_day    
  end

  class PalindromeDate
    def initialize(year)
      @year = year
    end

    def to_date
      Date.parse("#{@month}/#{@day}/#{@year}") rescue nil
    end
  end

  class America < PalindromeDate
    attr_reader :day, :month

    def initialize(year)
      super
      @month = year.to_s.reverse[0...2]
      @day = year.to_s.reverse[2...4]
    end
  end

  class Europe < PalindromeDate
    attr_reader :day, :month

    def initialize(year)
      super
      @day = year.to_s.reverse[0...2]
      @month = year.to_s.reverse[2...4]
    end
  end
end