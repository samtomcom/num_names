# Convert numbers to names
# SovietKetchup
# v1.1.1

module NumNames
  # Hash of pre-determined values for certain numbers
  LOOKUP =  { "1" => "one",
    "2" => "two",
    "3" => "three",
    "4" => "four",
    "5" => "five",
    "6" => "six",
    "7" => "seven",
    "8" => "eight",
    "9" => "nine",
    "10" => "ten",
    "11" => "eleven",
    "12" => "twelve",
    "13" => "thirteen",
    "14" => "fourteen",
    "15" => "fifteen",
    "16" => "sixteen",
    "17" => "seventeen",
    "18" => "eighteen",
    "19" => "nineteen",
    "20" => "twenty",
    "30" => "thirty",
    "40" => "fourty",
    "50" => "fifty",
    "60" => "sixty",
    "70" => "seventy",
    "80" => "eighty",
    "90" => "ninety"
  }

  # Convert the number into
  def to_word
    int_words = " "
    dec_words = "point"
    # Convert num into an array of strings e.g. 123 => ["1", "2", "3"] and put into groups of three
    num = self.to_s.dup
    # Negative numbers
    if num.match(/^-/)
      # Remove first character of the string
      num[0] = ""
      val = "negative "
    # Not a negative
    else
      val = ""
    end

    int = num.split(".").first.scan(/./).reverse.in_groups_of(3).map{ |g| g.compact.reverse }.reverse
    # A decimal
    if num.include? "."
      dec = num.split(".").last.scan(/./)
    # Not a decimal
    else
      dec = nil
    end

    pos = -1
    int.length.times {
      case pos
        when -1 then int_words = compile_i(int[pos]) + int_words
        when -2 then int_words = compile_i(int[pos]) + " thousand, " + int_words
        when -3 then int_words = compile_i(int[pos]) + " million, " + int_words
        when -4 then int_words = compile_i(int[pos]) + " billion, " + int_words
        when -5 then int_words = compile_i(int[pos]) + " trillion, " + int_words
        when -6 then int_words = compile_i(int[pos]) + " quadrillion, " + int_words
        when -7 then int_words = compile_i(int[pos]) + " quintillion, " + int_words
        when -8 then int_words = compile_i(int[pos]) + " sextillion, " + int_words
        when -9 then int_words = compile_i(int[pos]) + " septillion, " + int_words
        when -10 then int_words = compile_i(int[pos]) + " octillion, " + int_words
        when -11 then int_words = compile_i(int[pos]) + " nonillion, " + int_words
        when -12 then int_words = compile_i(int[pos]) + " decillion, " + int_words
      end
      pos -= 1
    }

    # Float value with dec
    unless dec == nil
      dec.each { |n|
        dec_words += " " + LOOKUP[n]
      }
      val += int_words + dec_words
    # Not a float
    else

      val += int_words
    end
    val
  end

  private
  # Compile the Integer Sections of 3 -- units, tens, hundreds
  def compile_i num_section
    ## raise LOOKUP[num_section[-2]].inspect
    # Only units
    if num_section.length == 1
      u = units num_section
    elsif num_section.length == 2
      u = units num_section; t = tens num_section
    else
      u = units num_section; t = tens num_section; h = hundreds num_section
    end
    h.to_s + t.to_s + u.to_s
  end

  # Names for numbers in the units
  def units n
    # Teen
    if n[-2] == "1"
      u = " " + LOOKUP[ n[-2] + n[-1] ]
    # Not a teen
    else
      u = " " + LOOKUP[ n[-1] ]
    end
    u
  end

  # Names for numbers in the tens
  def tens n
    # Not a teen
    unless n[-2] == "1" or n[-2] == nil
      t = LOOKUP[ n[-2] + "0" ]
    end
  end

  # Names for numbers in the hundreds
  def hundreds n
    unless n[-3] == "0" or n[-3] == nil
      if n[-1] == "0" and n[-2] == "0"
        h = LOOKUP[ n[-3] ] + " hundred "
      else
        h = LOOKUP[ n[-3] ] + " hundred and "
      end
    end
  end
end

# Extending Integer and Float to have .to_word
class Numeric; include NumNames; end

# http://api.rubyonrails.org/classes/Array.html#method-i-in_groups_of
class Array
  def in_groups_of(number, fill_with = nil)
    if number.to_i <= 0
    raise ArgumentError,
      "Group size must be a positive integer, was #{number.inspect}"
    end
    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat(Array.new(padding, fill_with))
    end
    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      collection.each_slice(number).to_a
    end
  end
end

puts -123.456.to_word
