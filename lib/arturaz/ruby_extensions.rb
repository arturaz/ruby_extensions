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
  end # }}}

  module TimeExtensions # {{{
    LT_MONTHS = %w[sausio vasario kovo balandžio gegužės birželio liepos 
    rugpjūčio rugsėjo spalio lapkričio gruodžio]

    # Returns time as word representation.
    #
    # options:
    #   :time - add time?
    #   :seconds - add seconds?
    def to_words(options={})
      options = {:time => true, :seconds => false}.merge(options)
      
      str = "%04d m. %s %02d d." % [year, LT_MONTHS[month - 1], day]
      if options[:time]
        str += " %02d:%02d" % [hour, min]        
        str += ":%02d" % sec if options[:seconds]
      end
      
      str
    end
    
    # Return time passed from now in lithuanian sentence
    # Supports minutes/hours/days. Anything else is reported as simple date.
    def ago_as_lt_words
      passed_by = ((Time.now - self) / 60).to_i
      
      if passed_by == 0
        return "ką tik"
      elsif passed_by < 60
        return as_lt_words(passed_by)
      else
        passed_by /= 60
        if passed_by < 60
          return as_lt_words(passed_by, ["valandą", "valandų", "valandas"])
        else
          passed_by /= 24
          if passed_by <= 31
            return as_lt_words(passed_by, ["dieną", "dienų", "dienas"])
          end
        end
      end
      
      to_words :time => true      
    end
    
    # Returns _number_ as lithuanian string.
    # _prefixes_ is array used for:
    # * 1, 21, 31, 41...
    # * 10..20, 30, 40...
    # * everything else
    def as_lt_words(number, prefixes=["minutę", "minučių", "minutes"])
      ones, tens, plural = prefixes
      last = number - (number / 10) * 10
      if last == 0 || (10..20).include?(number)
        "prieš %d #{tens}" % number
      elsif last == 1
        "prieš %d #{ones}" % number
      else
        "prieš %d #{plural}" % number
      end
    end
  end # }}}
end    

class String
  ALPHANUMERIC = "qwertyuiopasdfghjklzxcvbnm" +
    "QWERTYUIOPASDFGHJKLZXCVBNM1234567890"

  # Generate random alphanumeric _length_ long string.
  def self.random(length=8)
    str = ""
    an_length = ALPHANUMERIC.length - 1
    length.times { str += ALPHANUMERIC[rand(an_length)].chr }
    str
  end
end
