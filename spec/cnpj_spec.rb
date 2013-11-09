require "spec_helper"

describe CNPJ do
  it "blacklists common numbers" do
    expect(CNPJ).not_to be_valid("11111111111111")
    expect(CNPJ).not_to be_valid("22222222222222")
    expect(CNPJ).not_to be_valid("33333333333333")
    expect(CNPJ).not_to be_valid("44444444444444")
    expect(CNPJ).not_to be_valid("55555555555555")
    expect(CNPJ).not_to be_valid("66666666666666")
    expect(CNPJ).not_to be_valid("77777777777777")
    expect(CNPJ).not_to be_valid("88888888888888")
    expect(CNPJ).not_to be_valid("99999999999999")
  end

  it "rejects blank strings" do
    expect(CNPJ).not_to be_valid("")
  end

  it "rejects nil values" do
    expect(CNPJ).not_to be_valid(nil)
  end

  it "validates formatted strings" do
    number = "54.550.752/0001-55"
    expect(CNPJ).to be_valid(number)
  end

  it "validates unformatted strings" do
    number = "54550752000155"
    expect(CNPJ).to be_valid(number)
  end

  it "validates messed strings" do
    number = "54550[752#0001..$55"
    expect(CNPJ).to be_valid(number)
  end

  it "generates formatted number" do
    expect(CNPJ.generate(true)).to match(%r[\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z])
  end

  it "generates stripped number" do
    expect(CNPJ.generate).to match(/\A\d{14}\z/)
  end
end
