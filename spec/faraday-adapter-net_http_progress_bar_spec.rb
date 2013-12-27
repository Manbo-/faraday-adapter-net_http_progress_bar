require "spec_helper"

describe Faraday::Adapter::NetHttpProgressBar do
  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :net_http_progress_bar
    end
  end

  it do
    expect(ProgressBar).to receive(:create).and_return(ProgressBar.create)
    VCR.use_cassette "www.ruby-lang.org" do
      connection.get("http://www.ruby-lang.org")
    end
  end

  it do
    VCR.use_cassette "www.ruby-lang.org" do
      @response = connection.get("http://www.ruby-lang.org")
    end
    expect(@response).to be_a_kind_of Faraday::Response
  end
end
