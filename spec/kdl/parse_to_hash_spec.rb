RSpec.describe Kdl::Main do
  it "has a version number" do
    expect(Kdl::Main::VERSION).not_to be nil
  end

  it 'parses the basic.kdl' do
    file = File.read("spec/fixtures/files/basic.kdl")
    hash = Kdl::Main::Parse.to_h(file)

    expect(hash).to eq({"foo" => "foo", "bar" => "bar"})
  end

  it 'parses the cargo.kdl file' do
    file = File.read("spec/fixtures/files/cargo.kdl")

    hash = Kdl::Main::Parse.to_h(file)

    expect(hash).to eq(
      {
        "package" => {
          "name" => "kdl",
          "version" => "0.0.0",
          "description" => "kat's document language",
          "authors" => "Kat Marchán <kzm@zkat.tech>",
          "license-file" => "LICENSE.md",
          "edition" => "2018",
        },
        "dependencies" => {
          "nom" => "6.0.1",
          "thiserror" => "1.0.22",
        },
      }
    )
  end
end
