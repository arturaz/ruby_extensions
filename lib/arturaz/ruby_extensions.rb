require 'cgi'

module Arturaz
  module ArrayExtensions # {{{
    # Returns random member of array.
    def random
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
      str = self.clone
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
      self \
        .delithuanize \
        .gsub(%r{([^a-z0-9]|-)+}i, '-') \
        .gsub(%r{^-?(.*?)-?$}, '\1') \
        .downcase
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
      str = self.clone
      str[0] = str[0].chr.downcase
      str
    end
    
    # Downcase only first char.
    def downcase_first!
      self[0] = self[0].chr.downcase
    end
    
    # Upcase only first char.
    def upcase_first
      str = self.clone
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
        ["\r", ''],
        [%r{\b_(.*?)_\b}, '<em>\1</em>'],
        [%r{(\s|^)(www\..*?)(\s|$)}m, '\1<a href="http://\2">\2</a>\3'],
        [%r{(\s|^)http://(.*?)(\s|$)}m, '\1<a href="http://\2">\2</a>\3'],
        [%r{(\s|^)\[(www\..*?)\|(.*?)\](\s|$)}m, 
          '\1<a href="http://\2">\3</a>\4'],
        [%r{(\s|^)\[http://(.*?)\|(.*?)\](\s|$)}m, 
          '\1<a href="http://\2">\3</a>\4'],

        # TODO: === foo === leaves last ===
        [%r{^ *(=+)\s*(.*?)\s*(\1)?\ *$}, "<%h>\\2</%h>\n"],

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
    
    def htmlize(options={})
      if self.nil? or self.blank?
        ""
      else
        changed = CGI::escapeHTML(self)
        h = options[:heading] || 'h3'
        HTMLIZE_CHANGES[:stage1].each do |regexp, replacement|
          changed.gsub!(regexp, replacement)
        end
        changed = "<p>" + changed + "</p>"
        HTMLIZE_CHANGES[:stage2].each do |regexp, replacement|
          changed.gsub!(regexp, replacement)
        end
        changed.gsub(%r{<(/)?%h>}, "<\\1#{h}>")
      end
    end
  end # }}}

  module HashExtensions
    # Represent this hash in form useable in forms.
    #
    # E.g. self[:1][:2][:3] will become self['1[2][3]']
    def formify(key_format="%s")
      h = {}
      each do |k, v|
        k = key_format % k
        unless v.is_a? Hash
          h[k] = v
        else
          # 93 == ]
          k = (k[-1] == 93) ? "#{k[0..-2]}[%s]]" : "#{k}[%s]"
          v.formify(k).each do |k, v|
            h[k] = v
          end
        end
      end
      h
    end
  end
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
    chars.split(//).map do |char|
      new_code = set[char[0]]
      new_code.nil? ? char : new_code.chr
    end.join('')
  end
  
  # Un-ROT13 the string, but only alphanumeric parts.
  def an_unrot13
    an_rot13(ALPHANUMERIC_UNROT13)
  end
end
