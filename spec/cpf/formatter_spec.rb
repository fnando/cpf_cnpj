require "spec_helper"

describe CPF::Formatter do
  it "formats strings without separators" do
    number = "12345678909"
    expect(CPF::Formatter.format(number)).to eql("123.456.789-09")
  end

  it "removes any non-numeric characters" do
    number = "\n12.-34567$8909"
    expect(CPF::Formatter.strip(number)).to eql("12345678909")
  end
end
