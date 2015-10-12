require 'spec_helper'


describe Hashie::Extensions::I18n::Dash do

  class Greeting < Hashie::Dash
    include Hashie::Extensions::I18n::Dash
    localizable_property :hello, i18n: true, coerce: String
  end

  subject(:greeting){Greeting.new(attrs)}

  context "when setting to a Hash of translations" do
    let(:attrs){{hello: {en: "Hello", it: "Ciao"}}}

    describe "#:property" do
      it "returns the property as a Hash" do
        expect{subject}.not_to raise_error
        expect(subject.hello).to be_a Hash
      end
    end

    describe "#localized_:property" do
      it "correctly returns the provided translations" do
        expect(subject.localized_hello(:en)).to eq "Hello"
        expect(subject.localized_hello(:it)).to eq "Ciao"
      end

      it "returns nil for missing translations" do
        expect(subject.localized_hello(:fr)).to eq nil
      end
    end
  end

end
