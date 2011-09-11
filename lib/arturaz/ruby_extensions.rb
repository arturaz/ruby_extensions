# coding: utf-8
require 'cgi'

module RubyExtensions
  def self.youtube_width=(value); @@youtube_width = value; end
  def self.youtube_width; @@youtube_width; end
  def self.youtube_height=(value); @@youtube_height = value; end
  def self.youtube_height; @@youtube_height; end

  self.youtube_width = 480
  self.youtube_height = 385
end

module Arturaz
  module ArrayExtensions # {{{
    # Chooses a random array element from the receiver based on the weights
    # provided. If _weights_ is nil, then each element is weighed equally.
    # 
    #   [1,2,3].weighted_random          #=> 2
    #   [1,2,3].weighted_random          #=> 1
    #   [1,2,3].weighted_random          #=> 3
    #
    # If _weights_ is an array, then each element of the receiver gets its
    # weight from the corresponding element of _weights_. Notice that it
    # favors the element with the highest weight.
    #
    #   [1,2,3].weighted_random([1,4,1]) #=> 2
    #   [1,2,3].weighted_random([1,4,1]) #=> 1
    #   [1,2,3].weighted_random([1,4,1]) #=> 2
    #   [1,2,3].weighted_random([1,4,1]) #=> 2
    #   [1,2,3].weighted_random([1,4,1]) #=> 3
    #
    # If _weights_ is a symbol, the weight array is constructed by calling
    # the appropriate method on each array element in turn. Notice that
    # it favors the longer word when using :length.
    #
    #   ['dog', 'cat', 'hippopotamus'].weighted_random(:length) #=> "hippopotamus"
    #   ['dog', 'cat', 'hippopotamus'].weighted_random(:length) #=> "dog"
    #   ['dog', 'cat', 'hippopotamus'].weighted_random(:length) #=> "hippopotamus"
    #   ['dog', 'cat', 'hippopotamus'].weighted_random(:length) #=> "hippopotamus"
    #   ['dog', 'cat', 'hippopotamus'].weighted_random(:length) #=> "cat"
    #
    # It can also accept block instead of symbol.
    #
    #   ['dog', 'cat', 'hippopotamus'].weighted_random { |item| item.length }
    #
    # From: http://snippets.dzone.com/posts/show/898
    #
    def weighted_random(weights=nil)
      return weighted_random(map { |n| n.send(weights) }) \
        if weights.is_a? Symbol
      return weighted_random(map { |n| yield(n) }) \
        if weights.nil? and block_given?
      
      weights ||= Array.new(length, 1.0)
      total = weights.inject(0.0) { |total, weight| total + weight }
      point = Kernel.rand * total
      
      zip(weights).each do |n, weight|
        return n if weight >= point
        point -= weight
      end
    end

    #
    # Returns random member of array.
    def random_element
      self[rand(self.length)]
    end

    # Returns arithmetical average
    def average
      sum = 0.0
      self.each { |i| sum += i.to_f }
      if self.length == 0
        nil
      else
        sum / self.length
      end
    end

    # Alias for _average_ method.
    def avg
      average
    end

    def shuffle
      sort_by { rand }
    end

    def shuffle!
      self.replace shuffle
    end

    # Same as Array#uniq but accepts block argument which result will
    # be used for determining which values are unique.
    #
    #   a = ['a', 'A', 'bb', 'bB', 'Bb', 'Cc', 'cc']
    #   a.uniq { |i| i.downcase } # => ["a", "bb", "Cc"]
    def uniq_with_block(&block)
      if block
        first_values = {}
        map do |value|
          key = yield value
          first_values[key] ||= value
          first_values[key]
        end.uniq
      else
        uniq_without_block
      end
    end

    # Adds block support to Array#uniq!
    def uniq_with_block!(&block)
      if block
        replace uniq_with_block(&block)
      else
        uniq_without_block!
      end
    end

    # This is evil and it's only because of my lack of knowledge I guess.
    def self.append_features(mod)
      super(mod)
      mod.instance_eval do
        alias_method :uniq_without_block, :uniq
        alias_method :uniq, :uniq_with_block
        alias_method :uniq_without_block!, :uniq!
        alias_method :uniq!, :uniq_with_block!
      end
    end
  end # }}}
  
  module StringExtensions # {{{
    LOWERCASE_LITHUANIAN_LETTERS = ['ą', 'č', 'ę', 'ė', 'į', 'š', 'ų', 'ū', 'ž']
    UPPERCASE_LITHUANIAN_LETTERS = ['Ą', 'Č', 'Ę', 'Ė', 'Į', 'Š', 'Ų', 'Ū', 'Ž']
    LOWERCASE_LITHUANIAN_TO_LATIN_LETTERS = ['a', 'c', 'e', 'e', 'i', 's', 'u',
      'u', 'z']
    UPPERCASE_LITHUANIAN_TO_LATIN_LETTERS = ['A', 'C', 'E', 'E', 'I', 'S', 'U',
      'U', 'Z']
  
    # Converts lithuanian characters to latin ones.
    def delithuanize
      str = self.dup
      {
        LOWERCASE_LITHUANIAN_LETTERS => LOWERCASE_LITHUANIAN_TO_LATIN_LETTERS,
        UPPERCASE_LITHUANIAN_LETTERS => UPPERCASE_LITHUANIAN_TO_LATIN_LETTERS
      }.each_pair do |set_from, set_to|
        set_from.each_with_index do |letter, index|
          str.gsub!(letter, set_to[index])
        end
      end
      str
    end
    
    def delithuanize!
      self.replace delithuanize
    end
    
    def downcase_with_lithuanian_letters
      str = downcase_without_lithuanian_letters
      UPPERCASE_LITHUANIAN_LETTERS.each_with_index do |letter, index|
        str.gsub!(letter, LOWERCASE_LITHUANIAN_LETTERS[index])
      end
      str
    end
    
    def downcase!
      self.replace downcase
    end
    
    def upcase_with_lithuanian_letters
      str = upcase_without_lithuanian_letters
      LOWERCASE_LITHUANIAN_LETTERS.each_with_index do |letter, index|
        str.gsub!(letter, UPPERCASE_LITHUANIAN_LETTERS[index])
      end
      str
    end
    
    def upcase!
      self.replace upcase
    end
    
    def slugize!
      self.replace slugize
    end
    
    def slugize
      return "" if strip == ""

      str = self \
        .delithuanize \
        .gsub(%r{([^a-z0-9]|-)+}i, '-') \
        .gsub(%r{^-?(.*?)-?$}, '\1') \
        .downcase

      str == '' ? "-" : str
    end
    
    def slug?
      (self.match(%r{^[a-z0-9\-]+$}).nil?) ? false : true
    end    
    
    # Is this string is an email address?
    def email?
      not self.match(Rfc822::EmailAddress).nil?
    end
    
    # Append http:// to front of string if missing.
    def to_full_http_url
      if not self.blank? and self.match(%r{^https?://}).nil?
        "http://#{self}"
      else     
        self
      end
    end
    
    # Append http:// to front of string if missing. (IN PLACE)
    def to_full_http_url!
      self.replace to_full_http_url
    end
    
    # Downcase only first char.
    def downcase_first
      str = self.dup
      str[0] = str[0].chr.downcase
      str
    end
    
    # Downcase only first char.
    def downcase_first!
      self[0] = self[0].chr.downcase
    end
    
    # Upcase only first char.
    def upcase_first
      str = self.dup
      str[0] = str[0].chr.upcase
      str
    end
    
    # Upcase only first char.
    def upcase_first!
      self[0] = self[0].chr.upcase
    end
    
    # Replace all newlines with <br />'s
    def nl2br
      self.gsub("\n", "<br />")
    end

    # Prepend all single quotes with a backslash
    def escape_single_quotes
      self.gsub("'", "\\'")
    end
    
    # Get last number seperated by -'s
    def htmlid_to_i
      self.split('-')[-1].to_i
    end
    
    def startswith(str)
      (self.index(str) == 0) ? true : false
    end
    
    def endswith(str)
      index = self.rindex(str)
      if not index.nil? and (index + str.length) == self.length
        true
      else
        false
      end
    end
    
    HTMLIZE_CHANGES = {
      :stage1 => [
        [%r{^ *(=+)\s*(.*?)\s*(\1)?\ *$}m, "<%h>\\2</%h>\n"],

        ["\t", "  "],
        [/\n{2,}/, "</p>\t\t<p>"],
        ["\n", "<br />\n"],
        ["\t", "\n"]
      ],
      :stage2 => [
        ["<p><%h>", "<%h>"],
        ["</%h></p>", "</%h>"],
        ["<br />\n</p>", "</p>"],
        ["<br />\n<%h>", "</p>\n\n<%h>"]
      ]
    }

    YOUTUBE_LINK_REGEXP = %r{http://www.youtube.com/watch\?.*?v=([^&\s]+).*?(\s|$)}
    YOUTUBE_LINK_MARKER = "{%youtube_link_marker%}"
    NAMED_LINK_REGEXP = %r{\[(((\w+?)://(.+?))|(www\.[^\s]+))\|(.*?)\]}
    NAMED_LINK_MARKER = "{%named_link_marker%}"
    LINK_REGEXP = %r{(\b)(((\w+?)://(.+?))|(www\.[^\s]+))(\s|$)}m
    LINK_MARKER = "{%link_marker%}"
    
    def htmlize(options={})
      if self.nil? or self.strip.size == 0
        ""
      else
        changed = CGI::escapeHTML(self).gsub("\r", "")

        youtube_links = changed.scan(YOUTUBE_LINK_REGEXP)
        changed.gsub!(YOUTUBE_LINK_REGEXP, YOUTUBE_LINK_MARKER)
        named_links = changed.scan(NAMED_LINK_REGEXP)
        changed.gsub!(NAMED_LINK_REGEXP, NAMED_LINK_MARKER)
        links = changed.scan(LINK_REGEXP)
        changed.gsub!(LINK_REGEXP, LINK_MARKER)

        # Emphasize
        changed.gsub!(%r{\b_(.*?)_\b}, '<em>\1</em>')

        changed = changed.gsub(YOUTUBE_LINK_MARKER) do |match|
          id, end_symbol = youtube_links.shift
          url = "http://www.youtube.com/v/#{id}&hl=en&fs=1&rel=0"

          "<object width='#{RubyExtensions.youtube_width}' " +
            "height='#{RubyExtensions.youtube_height}'><param name='movie' " +
            "value='#{url}'></param><param " +
            "name='allowFullScreen' value='true'></param><param name='allowscriptaccess' " +
            "value='always'></param><embed src='#{url}' type='application/x-shockwave-flash' " +
            "allowscriptaccess='always' allowfullscreen='true' " +
            "width='#{RubyExtensions.youtube_width}' " +
            "height='#{RubyExtensions.youtube_height}'></embed></object>#{end_symbol}"
        end

        changed = changed.gsub(NAMED_LINK_MARKER) do |match|
          waste, waste, protocol, rest_of_link, www_link, text = named_links.shift
          href = protocol.nil? ? "http://#{www_link}" : "#{protocol}://#{rest_of_link}"
          "<a href='#{href}'>#{text}</a>"
        end

        changed = changed.gsub(LINK_MARKER) do |match|
          sep1, waste, waste, protocol, rest_of_link, www_link, sep2 = links.shift
          href, text = nil
          if protocol.nil?
            href = "http://#{www_link}"
            text = www_link
          else
            href = "#{protocol}://#{rest_of_link}"
            text = rest_of_link
          end
          "#{sep1}<a href='#{href}'>#{text}</a>#{sep2}"
        end

        h = options[:heading] || 'h3'
        HTMLIZE_CHANGES[:stage1].each do |regexp, replacement|
          changed.gsub!(regexp, replacement)
        end
        changed = "<p>" + changed + "</p>"
        HTMLIZE_CHANGES[:stage2].each do |regexp, replacement|
          changed.gsub!(regexp, replacement)
        end
        changed.gsub!(%r{<(/)?%h>}, "<\\1#{h}>")

        changed
      end
    end
  end # }}}

  module HashExtensions
    # Represent this hash in form useable in forms.
    #
    # E.g. self[:1][:2][:3] will become self['1[2][3]']
    def formify(key_format="%s")
      hash = {}
      each do |key, value|
        key = key_format % key
        unless value.is_a? Hash
          hash[key] = value
        else
          # 93 == ]
          key = (key[-1] == 93) ? "#{key[0..-2]}[%s]]" : "#{key}[%s]"
          value.formify(key).each do |key, value|
            hash[key] = value
          end
        end
      end
      hash
    end

    # Merges values from other hash. Calls block with both values if keys
    # match.
    #
    # Example:
    # 
    #  first = {:a => 10, :c => 20}
    #  second = {:b => 5, :c => 5}
    #
    #  first.merge_values!(second) do |a, b|
    #    a + b
    #  end
    #
    #  first.should == {:a => 10, :b => 5, :c => 25}
    #
    def merge_values!(other)
      other.each do |key, value|
        if has_key?(key)
          self[key] = yield self[key], value
        else
          self[key] = value
        end
      end
    end

    def flip
      self.class[*self.to_a.flatten.reverse]
    end

    # Maps values of +Hash+ returning new +Hash+ with it's values mapped.
    #
    #   source = {1 => 2, 3 => 4}
    #   source.map_values do |key, value|
    #     value * 2
    #   end.should == {1 => 4, 3 => 8}
    def map_values
      mapped = {}
      each do |key, value|
        mapped[key] = yield key, value
      end

      mapped
    end

    # Return new +Hash+ with only keys from whitelist.
    def only(*whitelist)
      {}.tap do |h|
        (keys & whitelist).each { |k| h[k] = self[k] }
      end
    end
  end
end

module Kernel
  def rangerand(min=nil, max=nil)
    if max.nil?
      old_rand(min)
    elsif min.nil?
      old_rand
    else
      min + old_rand((min - max).abs)
    end
  end

  def platform
    if RUBY_PLATFORM =~ /(win|w)32$/
      :windows
    elsif RUBY_PLATFORM =~ /linux$/
      :linux
    else
      :unknown
    end
  end
end
alias old_rand rand
# Rand with min/max behavior
def rand(min=nil, max=nil)
  Kernel.rangerand(min, max)
end

class String
  ALPHANUMERIC = ("qwertyuiopasdfghjklzxcvbnm" +
    "QWERTYUIOPASDFGHJKLZXCVBNM1234567890").freeze
  ALPHANUMERIC_ROT13 = {}
  ALPHANUMERIC_UNROT13 = {}
  0.upto(ALPHANUMERIC.length - 1) do |index|
    new_index = index + 13
    new_index -= 62 if new_index >= 62
    ALPHANUMERIC_ROT13[ALPHANUMERIC[index]] = ALPHANUMERIC[new_index]
    ALPHANUMERIC_UNROT13[ALPHANUMERIC[new_index]] = ALPHANUMERIC[index]
  end
  ALPHANUMERIC_ROT13.freeze
  ALPHANUMERIC_UNROT13.freeze

  # Generate random alphanumeric _length_ long string.
  def self.random(length=8)
    str = ""
    an_length = ALPHANUMERIC.length - 1
    length.times { str += ALPHANUMERIC[rand(an_length)].chr }
    str
  end
  
  # ROT13 the string, but only alphanumeric parts.
  def an_rot13(set=ALPHANUMERIC_ROT13)
    mb_chars.split(//).map do |char|
      new_code = set[char[0]]
      new_code.nil? ? char : new_code.chr
    end.join('')
  end
  
  # Un-ROT13 the string, but only alphanumeric parts.
  def an_unrot13
    an_rot13(ALPHANUMERIC_UNROT13)
  end

  def diff(other_str)
    ver1 = scan(/./)
    ver2 = other_str.scan(/./)

    i = 0
    until ver1.blank?
      char1 = ver1.shift
      char2 = ver2.shift

      if char1 != char2
        puts "#{char1} != #{char2} @ char #{i}!!!"
        puts "self: #{char1}#{ver1.join('')}"
        puts "other_str: #{char2}#{ver2.join('')}"
      end
    end
  end
end

class Fixnum
  def to_minutes_and_seconds
    minutes = self / 60
    seconds = self % 60
    [minutes, seconds]
  end
end

class Float
  alias :old_round :round

  # Round float to number of places:
  #
  # >> 0.538305321343516.round             => 1
  # >> 0.538305321343516.round(1)          => 0.5
  # >> 0.538305321343516.round(2)          => 0.54
  # >> 0.538305321343516.round(3)          => 0.538
  #
  def round(places=0)
    if places == 0
      old_round
    else
      raise ArgumentError.new(
        "Places must be positive! #{places.inspect} given") if places < 0
      places = places.to_i
      rounder = (10 ** places).to_f
      (self * rounder).old_round / rounder
    end
  end
end

class Time
  # Returns _self_ with #usec set to 0
  def drop_usec
    Time.at(to_i)
  end
end

class Object
  # Try calling _method_ if it's available. If it's not available, just
  # return +nil+.
  #
  def try_method(method, *args)
    if respond_to?(method)
      send(method, *args)
    else
      nil
    end
  end
end

class Range
  def *(value)
    (first * value)..(last * value)
  end
  
  def /(value)
    (first / value)..(last / value)
  end
end

class Random
  # Return boolean value based on integer _chance_.
  def self.chance(chance)
    rand(100) + 1 <= chance
  end
end

module Enumerable
  # Hash by given block.
  #
  # Example:
  # [
  #   {:id => 1, :name => '1'},
  #   {:id => 2, :name => '2'},
  #   {:id => 3, :name => '3'},
  # ].hash_by { |item| item[:id] }.should == {
  #   1 => {:id => 1, :name => '1'},
  #   2 => {:id => 2, :name => '2'},
  #   3 => {:id => 3, :name => '3'}
  # }
  #
  def hash_by
    hash = {}
    each do |item|
      hash[yield item] = item
    end
    hash
  end

  # Acts as #group_by. Groups array by given block but retuns Hash instead
  # of Array.
  #
  # Example:
  #  class GroupToHashTest
  #    def initialize(num); @num = num; end
  #    def test; "%03d" % @num; end
  #  end
  #
  #  g1 = GroupToHashTest.new(1)
  #  g2 = GroupToHashTest.new(3)
  #  g3 = GroupToHashTest.new(1)
  #
  #  [g1, g2, g3].group_to_hash { |i| i.test }.should == {
  #    "001" => [g1, g3],
  #    "003" => [g2]
  #  }
  #
  def group_to_hash
    grouped = {}

    each do |item|
      group_id = yield item
      grouped[group_id] ||= []
      grouped[group_id].push item
    end

    grouped
  end

  # Groups given array members and returns a hash consisting of
  # type => count pairs. If block is given it determines type by block
  # return value. Members are used otherwise.
  # 
  # Example:
  #  class GroupedCountsByTest
  #    def initialize(num); @num = num; end
  #    def test; "%03d" % @num; end
  #  end
  #
  #  [
  #    GroupedCountsByTest.new(1),
  #    GroupedCountsByTest.new(3),
  #    GroupedCountsByTest.new(3),
  #    GroupedCountsByTest.new(1),
  #    GroupedCountsByTest.new(5),
  #    GroupedCountsByTest.new(5),
  #    GroupedCountsByTest.new(1)
  #  ].grouped_counts { |i| i.test }.should == {
  #    "001" => 3,
  #    "003" => 2,
  #    "005" => 2
  #  }
  def grouped_counts(&block)
    grouped = {}

    each do |item|
      item = block_given? ? block.call(item) : item
      grouped[item] ||= 0
      grouped[item] += 1
    end

    grouped
  end

  # Acts like #map but returns +Hash+ of {original => mapped} pairs
  # instead of +Array+.
  #
  # Example:
  # [1,2,3].map_to_hash { |i| i ** 2 }.should == {
  #   1 => 1,
  #   2 => 4,
  #   3 => 9
  # }
  #
  def map_to_hash
    hash = {}
    each do |item|
      hash[item] = yield(item)
    end
    hash
  end

  # Acts like #map but returns +Hash+ of {key => value} pairs
  # instead of +Array+. Your block must return [key, value] pairs.
  #
  # Example:
  #  [1,2,3].map_into_hash { |i| [i.to_s, i ** 2] }.should == {
  #    "1" => 1,
  #    "2" => 4,
  #    "3" => 9
  #  }
  #
  def map_into_hash
    hash = {}
    each do |item|
      key, value = yield(item)
      hash[key] = value
    end
    hash
  end
  
  def accept
    reject { |item| ! yield(item) }
  end

  def accept!
    reject! { |item| ! yield(item) }
  end
end