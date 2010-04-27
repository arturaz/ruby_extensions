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
      class GroupToHashTest
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