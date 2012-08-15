shared_examples_for "validation" do
  it "fails when providing Invalid number" do
    capture_exit(1) do
      described_class.new([switch, "invalid"], stdin, stdout, stderr).start
    end

    expect(stderr).to include("Error: Invalid number")
  end

  it "fails when not providing a number" do
    capture_exit(1) do
      described_class.new([switch], stdin, stdout, stderr).start
    end

    expect(stderr).to include("Error: Invalid number")
  end
end
