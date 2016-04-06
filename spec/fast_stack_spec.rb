require 'fast_stack'


RSpec.describe String do

  it "works for c mode" do
    s = FastStack.profile(1, :c) do
      t = Time.new
      while (Time.new - t) < 0.01 do
        "nothing"
      end
    end

    expect(s.count).to be > 2
  end

  it "works" do
    s = FastStack.profile do
      t = Time.new
      while (Time.new - t) < 0.1 do
        "nothing"
      end
    end

    expect(s.count).to be > 2
  end

  def fib( n )
    return  n  if ( 0..1 ).include? n
    ( fib( n - 1 ) + fib( n - 2 ) )
  end

  it "fibos" do
    s = FastStack.profile do
      fib(30)
    end

    expect(s.count).to be > 10
  end
end
