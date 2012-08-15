require "spec_helper"

describe CPF::Generator do
  it "generates valid numbers" do
    expect(CPF).to be_valid(CPF::Generator.generate)
    expect(CPF).to be_valid(CPF::Generator.generate)
    expect(CPF).to be_valid(CPF::Generator.generate)
    expect(CPF).to be_valid(CPF::Generator.generate)
    expect(CPF).to be_valid(CPF::Generator.generate)
  end

  it "generates random numbers" do
    expect(CPF::Generator.generate).not_to eql(CPF::Generator.generate)
  end
end
