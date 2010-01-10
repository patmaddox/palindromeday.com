require 'palindrome_day'

describe PalindromeDay do
  it { PalindromeDay.in_year(2010).should == Date.parse('01/02/2010') }
  it { PalindromeDay.in_year(2011).should == Date.parse('11/02/2011') }
  it { PalindromeDay.in_year(2012).should be_nil }
  it "should find next palindrome day" do
    twenty_ten = Date.parse '01/01/2010'
    Date.stub!(:today).and_return twenty_ten
    PalindromeDay.next.should == Date.parse('01/02/2010')
    twenty_twelve = Date.parse '01/01/2012'
    Date.stub!(:today).and_return twenty_twelve
    PalindromeDay.next.should == Date.parse('02/02/2020')
  end

  it "should find next palindrome day starting at a certain year" do
    PalindromeDay.next(Date.parse('01/01/2010')).should == Date.parse('01/02/2010')
    PalindromeDay.next(Date.parse('01/03/2010')).should == Date.parse('11/02/2011')
    PalindromeDay.next(Date.parse('01/01/2012')).should == Date.parse('02/02/2020')
  end

  it { PalindromeDay.europe(2010).should == Date.parse('02/01/2010') }
  it { PalindromeDay.europe(2011).should == Date.parse('02/11/2011') }
end