require "spec_helper"

describe CNPJ::Generator do
  it "generates valid numbers" do
    expect(CNPJ).to be_valid(CNPJ::Generator.generate)
    expect(CNPJ).to be_valid(CNPJ::Generator.generate)
    expect(CNPJ).to be_valid(CNPJ::Generator.generate)
    expect(CNPJ).to be_valid(CNPJ::Generator.generate)
    expect(CNPJ).to be_valid(CNPJ::Generator.generate)
  end

  it "generates random numbers" do
    expect(CNPJ::Generator.generate).not_to eql(CNPJ::Generator.generate)
  end
end
