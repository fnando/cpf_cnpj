require "spec_helper"

describe CNPJ::Formatter do
  it "formats strings without separators" do
    number = "12345678901234"
    expect(CNPJ::Formatter.format(number)).to eql("12.345.678/9012-34")
  end

  it "removes any non-numeric characters" do
    number = "\n12$345[678/9012-34"
    expect(CNPJ::Formatter.strip(number)).to eql("12345678901234")
  end
end
