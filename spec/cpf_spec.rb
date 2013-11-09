require "spec_helper"

describe CPF do
  it "blacklists common numbers" do
    expect(CPF).not_to be_valid("11111111111")
    expect(CPF).not_to be_valid("22222222222")
    expect(CPF).not_to be_valid("33333333333")
    expect(CPF).not_to be_valid("44444444444")
    expect(CPF).not_to be_valid("55555555555")
    expect(CPF).not_to be_valid("66666666666")
    expect(CPF).not_to be_valid("77777777777")
    expect(CPF).not_to be_valid("88888888888")
    expect(CPF).not_to be_valid("99999999999")
    expect(CPF).not_to be_valid("12345678909")
  end

  it "rejects blank strings" do
    expect(CPF).not_to be_valid("")
  end

  it "rejects nil values" do
    expect(CPF).not_to be_valid(nil)
  end

  it "validates formatted strings" do
    number = "295.379.955-93"
    expect(CPF).to be_valid(number)
  end

  it "validates unformatted strings" do
    number = "29537995593"
    expect(CPF).to be_valid(number)
  end

  it "validates messed strings" do
    number = "295$379\n955...93"
    expect(CPF).to be_valid(number)
  end

  it "returns stripped number" do
    cpf = CPF.new("295.379.955-93")
    expect(cpf.stripped).to eql("29537995593")
  end

  it "formats number" do
    cpf = CPF.new("29537995593")
    expect(cpf.formatted).to eql("295.379.955-93")
  end

  it "generates formatted number" do
    expect(CPF.generate(true)).to match(/\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/)
  end

  it "generates stripped number" do
    expect(CPF.generate).to match(/\A\d{11}\z/)
  end

  context "memoization" do
    let(:cpf) { CPF.new("29537995593") }

    before do
      cpf.number = "52139989171"
    end

    it "invalidates stripped number" do
      expect(cpf.stripped).to eql("52139989171")
    end

    it "invalidates formatted number" do
      expect(cpf.formatted).to eql("521.399.891-71")
    end
  end
end
