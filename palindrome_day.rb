class PalindromeDay
  def self.in_year(year)
    America.new(year).to_date
  end

  def self.europe(year)
    Europe.new(year).to_date
  end

  def self.next
    find_next :in_year
  end

  def self.next_europe
    find_next :europe   
  end

  private

  def self.find_next(finder)
    this_year = Date.today.year
    while (palindrome_day = send(finder, this_year)).nil?
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