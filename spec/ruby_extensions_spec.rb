# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe String do
  describe "#htmlize" do
    it "should embed youtube videos" do
      id = "-ueVas1suo8"
      url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"
      "http://www.youtube.com/watch?v=#{id}".htmlize.should == \
        "<p><object width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
          "value='#{url}'></param><param " +
          "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
          "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'></embed></object></p>"
    end

    it "should embed youtube videos no matter how params are passed" do
      id = "-ueVas1suo8"
      url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"
      "http://www.youtube.com/watch?foo=bar&v=#{id}&lol=cat".htmlize.should == \
        "<p><object width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
          "value='#{url}'></param><param " +
          "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
          "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'></embed></object></p>"
    end

    it "should embed youtube videos in middle of text (space at end of link)" do
      id = "-ueVas1suo8"
      url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"
      ("check out this video: " +
      "http://www.youtube.com/watch?foo=bar&v=#{id}&lol=cat " +
      "it's amazing!!").htmlize.should == \
        "<p>check out this video: <object width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
          "value='#{url}'></param><param " +
          "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
          "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'></embed></object> it's amazing!!</p>"
    end

    it "should embed youtube videos in middle of text (id ends with space)" do
      id = "-ueVas1suo8"
      url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"
      text = "omg omg http://www.youtube.com/watch?v=#{id} afigieet"
      text.htmlize.should == \
        "<p>omg omg <object width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
          "value='#{url}'></param><param " +
          "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
          "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'></embed></object> afigieet</p>"
    end

    it "should embed youtube videos in middle of text (\\n at end of link)" do
      id = "-ueVas1suo8"
      url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"
      ("check out this video: " +
      "http://www.youtube.com/watch?foo=bar&v=#{id}&lol=cat").htmlize.should == \
        "<p>check out this video: <object width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
          "value='#{url}'></param><param " +
          "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
          "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "width='#{RubyExtensions.youtube_width}' " +
          "height='#{RubyExtensions.youtube_height}'></embed></object></p>"
    end

    it "should not emphasize inside of links" do
      "http://www.myspace.com/_x_ray_".htmlize.should == \
        "<p><a href='http://www.myspace.com/_x_ray_'>www.myspace.com/_x_ray_</a></p>"
    end

    it "should link www links" do
      "www.myspace.com/djmamania".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a></p>"
    end

    it "should link named www links" do
      "[www.myspace.com/djmamania|mamania]".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>mamania</a></p>"
    end

    it "should link http links" do
      "http://www.myspace.com/djmamania".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a></p>"
    end

    it "should link named http links" do
      "[http://www.myspace.com/djmamania|mamania]".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>mamania</a></p>"
    end

    it "should link named http links in middle of text" do
      "nom,[https://lol.com/omgwtf|https link], should be a link.".htmlize.should == \
        "<p>nom,<a href='https://lol.com/omgwtf'>https link</a>, should be a link.</p>"
    end

    it "should link both links on same line (www)" do
      "www.myspace.com/djmamania www.myspace.com/djmantini".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a> " +
        "<a href='http://www.myspace.com/djmantini'>www.myspace.com/djmantini</a></p>"
    end

    it "should link both links on same line (http)" do
      "http://www.myspace.com/djmamania http://www.myspace.com/djmantini".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a> " +
        "<a href='http://www.myspace.com/djmantini'>www.myspace.com/djmantini</a></p>"
    end

    it "should link both links on same line (http/www)" do
      "http://www.myspace.com/djmamania www.myspace.com/djmantini".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a> " +
        "<a href='http://www.myspace.com/djmantini'>www.myspace.com/djmantini</a></p>"
    end
    
    it "should link both links on same line (www/http)" do
      "www.myspace.com/djmamania http://www.myspace.com/djmantini".htmlize.should == \
        "<p><a href='http://www.myspace.com/djmamania'>www.myspace.com/djmamania</a> " +
        "<a href='http://www.myspace.com/djmantini'>www.myspace.com/djmantini</a></p>"
    end

    it "should corretcly format multiple links on multiple lines" do
      "www.a.lt\nwww.b.lt".htmlize.should == \
        "<p><a href='http://www.a.lt'>www.a.lt</a><br />
<a href='http://www.b.lt'>www.b.lt</a></p>"
    end

    it "should pass the most complex test evah!" do
      text =<<EOF
== test!
this should be a paragraph

but this
is
a
paragraph
with
newlines

nom,[http://lol.com/omgwtf|Foo], should be a link.
nom,[https://lol.com/omgwtf|https link], should be a link.

=a heading
some text
== also a heading
some text

== lots of headings today... ==
some text

== a heading alone

and this = ain't a heading =

it should <encode> html too so no <script> tags would pass

I support _emphasis inline here_ and _here_
_emphasis_

But it should not a_emphasize_this

i also support www.links.com and http://links.com
www.links.com
http://www.links.com/ should not break too...
by the way, i support [http://foo|named links] too
[www.azuras.lt|Ažūras]
EOF
      expected =<<EOF
<h3>test!</h3>

<p>this should be a paragraph</p>

<p>but this<br />
is<br />
a<br />
paragraph<br />
with<br />
newlines</p>

<p>nom,<a href='http://lol.com/omgwtf'>Foo</a>, should be a link.<br />
nom,<a href='https://lol.com/omgwtf'>https link</a>, should be a link.</p>

<h3>a heading</h3>

<p>some text</p>

<h3>also a heading</h3>

<p>some text</p>

<h3>lots of headings today...</h3>

<p>some text</p>

<h3>a heading alone</h3>

<p>and this = ain't a heading =</p>

<p>it should &lt;encode&gt; html too so no &lt;script&gt; tags would pass</p>

<p>I support <em>emphasis inline here</em> and <em>here</em><br />
<em>emphasis</em></p>

<p>But it should not a_emphasize_this</p>

<p>i also support <a href='http://www.links.com'>www.links.com</a> and <a href='http://links.com'>links.com</a><br />
<a href='http://www.links.com'>www.links.com</a><br />
<a href='http://www.links.com/'>www.links.com/</a> should not break too...<br />
by the way, i support <a href='http://foo'>named links</a> too<br />
<a href='http://www.azuras.lt'>Ažūras</a></p>
EOF
      text.htmlize.strip.should == expected.strip
    end
  end

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

  describe "#delithuanize" do
    it "should remove lithuanian letters" do
      "ąčęėįšųūžĄČĘĖĮŠŲŪŽ".delithuanize.should == "aceeisuuzACEEISUUZ"
    end

    it "should remove ž" do
      "Didžioji".delithuanize.should == "Didzioji"
    end
  end
end

describe Array do
  describe "#hash_by" do
    it "should return a Hash" do
      [
        {:id => 1, :name => '1'},
        {:id => 2, :name => '2'},
        {:id => 3, :name => '3'},
      ].hash_by { |item| item[:id] }.should == {
        1 => {:id => 1, :name => '1'},
        2 => {:id => 2, :name => '2'},
        3 => {:id => 3, :name => '3'}
      }
    end
  end

  describe "#map_to_hash" do
    it "should return a Hash" do
      [1,2,3].map_to_hash { |i| i ** 2 }.should == {
        1 => 1,
        2 => 4,
        3 => 9
      }
    end
  end

  describe "#map_into_hash" do
    it "should return a Hash" do
      [1,2,3].map_into_hash { |i| [i.to_s, i ** 2] }.should == {
        "1" => 1,
        "2" => 4,
        "3" => 9
      }
    end
  end

  describe "#shuffle" do
    it "should shuffle the array" do
      array = [1,2,3,4,5]
      array.should_not eql(array.shuffle)
    end
  end

  describe "#shuffle!" do
    it "should replace the array with shuffled version" do
      array = [1,2,3,4,5]
      orig_array = array.dup
      array.shuffle!
      array.should_not eql(orig_array)
    end
  end

  describe "#group_to_hash" do
    it "should group to hash" do
      class GroupedCountsByTest
        def initialize(num); @num = num; end
        def test; "%03d" % @num; end
      end

      g1 = GroupedCountsByTest.new(1)
      g2 = GroupedCountsByTest.new(3)
      g3 = GroupedCountsByTest.new(1)

      [g1, g2, g3].group_to_hash { |i| i.test }.should == {
        "001" => [g1, g3],
        "003" => [g2]
      }
    end
  end

  describe "#grouped_counts_by" do
    it "should group and count by given method" do
      class GroupedCountsByTest
        def initialize(num); @num = num; end
        def test; "%03d" % @num; end
      end

      [
        GroupedCountsByTest.new(1),
        GroupedCountsByTest.new(3),
        GroupedCountsByTest.new(3),
        GroupedCountsByTest.new(1),
        GroupedCountsByTest.new(5),
        GroupedCountsByTest.new(5),
        GroupedCountsByTest.new(1)
      ].grouped_counts { |i| i.test }.should == {
        "001" => 3,
        "003" => 2,
        "005" => 2
      }
    end
  end
end

describe Hash do
  describe "#merge_values!" do
    it "should merge two hashes" do
      first = {:a => 10, :c => 20}
      second = {:b => 5, :c => 5}

      first.merge_values!(second) do |a, b|
        a + b
      end

      first.should == {:a => 10, :b => 5, :c => 25}
    end
  end

  describe "#only" do
    let(:hash) { {:a => 1, :b => 2, :c => 3} }

    it "should support key array" do
      hash.only([:a, :b]).should == {:a => 1, :b => 2}
    end

    it "should support multiple arguments" do
      hash.only(:a, :b).should == {:a => 1, :b => 2}
    end
  end

  describe "#map_keys" do
    it "should map keys" do
      source = {1 => 2, 3 => 4}
      source.map_keys do |key, value|
        key * 2
      end.should == {2 => 2, 6 => 4}
    end
  end

  describe "#map_values" do
    it "should map values" do
      source = {1 => 2, 3 => 4}
      source.map_values do |key, value|
        value * 2
      end.should == {1 => 4, 3 => 8}
    end
  end

  describe "#map_values!" do
    it "should map values in-place" do
      source = {1 => 2, 3 => 4}
      source.map_values! do |key, value|
        value * 2
      end
      source.should == {1 => 4, 3 => 8}
    end
  end

  describe "#ensure_options!" do
    describe "requirements" do
      it "should raise ArgumentError if required param " +
      "is missing" do
        lambda do
          hash = {'aa' => 10}
          hash.ensure_options! :required => 'lol'
        end.should raise_error(ArgumentError)
      end

      it "should support array syntax" do
        lambda do
          hash = {'foo' => 10, 'bar' => 20}
          hash.ensure_options! :required => %w{foo bar}
        end.should_not raise_error(ArgumentError)
      end

      it "should support hash syntax" do
        lambda do
          hash = {:foo => 10, :bar => "20"}
          hash.ensure_options! :required => {:foo => Fixnum, :bar => String}
        end.should_not raise_error(ArgumentError)
      end

      it "should support multiple type checking" do
        lambda do
          hash = {:foo => 10, :bar => false}
          hash.ensure_options! :required => {:foo => Fixnum,
            :bar => [TrueClass, FalseClass]}
        end.should_not raise_error(ArgumentError)
      end

      it "should fail if types mismatch" do
        lambda do
          hash = {:foo => 10, :bar => nil}
          hash.ensure_options! :required => {:foo => Fixnum,
            :bar => [TrueClass, FalseClass]}
        end.should raise_error(ArgumentError)
      end

      it "should pass if required params is given" do
        lambda do
          hash = {'lol' => 10}
          hash.ensure_options! :required => 'lol'
        end.should_not raise_error(ArgumentError)
      end
    end

    describe "validity" do
      it "should raise ArgumentError if param is not from valid list" do
        lambda do
          hash = {'aa' => 10}
          hash.ensure_options! :valid => 'lol'
        end.should raise_error(ArgumentError)
      end

      it "should pass if params are from valid list" do
        lambda do
          hash = {'lol' => 10}
          hash.ensure_options! :valid => 'lol'
        end.should_not raise_error(ArgumentError)
      end
    end

    it "should pass if all params are valid and required are provided" do
      lambda do
        hash = {'baz' => 10, 'lol' => 20}
        hash.ensure_options! :valid => 'lol', :required => 'baz'
      end.should_not raise_error(ArgumentError)
    end
  end
end

describe Fixnum do
  describe "#to_minutes_and_seconds" do
    it "should work for 0" do
      0.to_minutes_and_seconds.should == [0, 0]
    end

    it "should work for intervals under a minute" do
      30.to_minutes_and_seconds.should == [0, 30]
    end

    it "should work for intervals over a minute" do
      75.to_minutes_and_seconds.should == [1, 15]
    end

    it "should work on marginal minutes" do
      120.to_minutes_and_seconds.should == [2, 0]
    end
  end
end

describe Object do
  describe "#try_method" do
    it "should call method if available" do
      "foo".try_method(:length).should == 3
    end

    it "should return nil if unavailable" do
      "foo".try_method(:i_do_not_exist).should be_nil
    end
  end
end

describe Enumerable do
  describe "#compact_map" do
    it "should return mapped enumerable without nil values" do
      source = [1, 2, 3, 4, 5, 6]
      actual = source.compact_map { |i| i % 2 == 0 ? i * 2 : nil }
      actual.should == [4, 8, 12]
    end
  end

  describe "#deep_flat_map" do
    it "should recursively map everything into single array" do
      source = [[1, 2, [3, 4, [5, 6], [7, 8]], 9, [10]], 11, [12, 13], 14, 15]
      actual = source.deep_flat_map { |i| i - 1 }
      actual.should == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    end
  end
end

describe Range do
  describe "#random_element" do
    it "should return a number between range start and end" do
      value = (5..10).random_element
      value.should >= 5
      value.should <= 10
    end
  end
end