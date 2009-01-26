require File.dirname(__FILE__) + '/spec_helper'

describe String do
  describe "#slugize" do
    it "should return '' for blank string" do
      "    ".slugize.should == ''
    end

    it "should not leave string empty" do
      "-----".slugize.should == "-"
    end

    it "should remove -'s from string ends" do
      "--foobar--".slugize.should == "foobar"
    end
  end
end