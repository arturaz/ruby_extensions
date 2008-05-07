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

  module IntegerExtensions
    # Returns _self_ as lithuanian string.
    # 3 arguments used for:
    # * 1, 21, 31, 41...
    # * 0, 10..20, 30, 40...
    # * everything else
    def as_lt_words(ones, tens, plural)
      last = self - (self / 10) * 10
      if last == 0 || (10..20).include?(self)
        "%d #{tens}" % self
      elsif last == 1
        "%d #{ones}" % self
      else
        "%d #{plural}" % self
      end
    end
    
    # Return _self_ as lithuanian second string
    def as_lt_seconds(variation=:ago)
      case variation 
      when :ago
        as_lt_words("sekundę", "sekundžių", "sekundes")
      when :noun
        as_lt_words("sekundė", "sekundžių", "sekundės")
      when :since
        as_lt_words("sekundės", "sekundžių", "sekundžių")
      end
    end
    
    # Return _self_ as lithuanian minute string
    def as_lt_minutes(variation=:ago)
      case variation 
      when :ago
        as_lt_words("minutę", "minučių", "minutes")
      when :noun
        as_lt_words("minutė", "minučių", "minutės")
      when :since
        as_lt_words("minutės", "minučių", "minučių")
      end
    end
    
    # Return _self_ as lithuanian hour string
    def as_lt_hours(variation=:ago)
      case variation 
      when :ago
        as_lt_words("valandą", "valandų", "valandas")
      when :noun
        as_lt_words("valanda", "valandų", "valandos")
      when :since
        as_lt_words("valandos", "valandų", "valandų")
      end
    end
    
    # Return _self_ as lithuanian day string
    def as_lt_days(variation=:ago)
      case variation 
      when :ago
        as_lt_words("dieną", "dienų", "dienas")
      when :noun
        as_lt_words("diena", "dienų", "dienos")
      when :since
        as_lt_words("dienos", "dienų", "dienų")
      end
    end
    
    # Return _self_ as lithuanian week string
    def as_lt_weeks(variation=:ago)
      case variation 
      when :ago
        as_lt_words("savaitę", "savaičių", "savaites")
      when :noun
        as_lt_words("savaitė", "savaičių", "savaitės")
      when :since
        as_lt_words("savaitės", "savaičių", "savaičių")
      end
    end
  end
  
  module TimeExtensions # {{{
    module InstanceMethods
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

      # Return time as lithuanian string. Pass true to _detailed_ to get
      # word and exact time
      def as_lt_words(detailed=false)
        (Time.now > self ? ago_as_lt_words : since_as_lt_words) + 
          (detailed ? " (#{to_words(:time => true)})" : '')
      rescue ArgumentError
        to_words :time => true
      end

      def ago_as_lt_words
        "prieš " + self.class.distance_in_lt_words(Time.now - self, :ago)
      end

      def since_as_lt_words
        "už " + self.class.distance_in_lt_words(self - Time.now, :since)
      end
    end
    
    module ClassMethods    
      # Returns distance in _seconds_ in lithuanian words. Max arg: 31 days.
      def distance_in_lt_words(seconds, variation=:noun)
        seconds = seconds.round
        if seconds < 60
          return seconds.as_lt_seconds(variation)
        else
          minutes = seconds / 60
          seconds -= minutes * 60
          if minutes < 60
            return minutes.as_lt_minutes(variation) + 
              (seconds == 0 ? '' : ' ir ' + seconds.as_lt_seconds(variation))
          else
            hours = minutes / 60
            minutes -= hours * 60
            if hours < 24
              return hours.as_lt_hours(variation) + 
                (minutes == 0 ? '' : ' ir ' + minutes.as_lt_minutes(variation))
            else
              days = hours / 24
              hours -= days * 24
              if days <= 31
                if days >= 7
                  weeks = days / 7
                  days -= weeks * 7

                  return weeks.as_lt_weeks(variation) + 
                    (days == 0 ? '' : ' ir ' + days.as_lt_days(variation))
                else              
                  return days.as_lt_days(variation) +
                    (hours == 0 ? '' : ' ir ' + hours.as_lt_hours(variation))
                end
              else
                raise ArgumentError.new(
                  "Difference is too big! Try using #to_words.")
              end
            end
          end
        end
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
