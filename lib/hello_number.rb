require 'optparse'

class HelloNumber < OptionParser
  attr_accessor :phone, :file_path, :data, :match_words, :possible_words
  def initialize
    super
    self.on("-d", "--dictionary DICTIONARY", String) { | v | @file_path = v }
    self.on("-p", "--phone PHONE NUMBER", String) { | v | @phone = v }    
    @data = []
    @match_words = []
    @possible_words = {}
  end  

  # Basically, process a file with given letters of possible combinations. Also checks validations
  def process
    return unless is_valid?
    updateToLog("Loading Dictionary...")

    load_dictionary
    generate_combination
    updateToLog("Creating Combination...")

    updateToLog("Looking For Match Words...")
    possible_words.each do |nlen, nwords|
      match_words << (data & nwords).first.upcase rescue ""
    end
    updateToLog("Output: #{match_words.join("-")}")
    match_words
  end

  # Mobile Numpad, Values and Alpha
  def numpad
    @_numpad ||= {"2" => ["a", "b", "c"],"3" => ["d", "e", "f"],"4" => ["g", "h", "i"],"5" => ["j", "k", "l"],"6" => ["m", "n", "o"],"7" => ["p", "q", "r", "s"],"8" => ["t", "u", "v"],"9" => ["w", "x", "y", "z"]}
  end

  # Load the given dictionary into array.
  def load_dictionary
    File.foreach(file_path) do |word|
      data << word.chop.to_s.downcase
    end
  end

  # Generate Possibles match words with given letter based on length
  def generate_combination
    uniq_numbers.each do |klen, v|
      tmp_arr = []
      v.each {|e| tmp_arr += numpad[e]}
      possible_words[klen] ||= {} 
      possible_words[klen] = tmp_arr.repeated_permutation(klen.to_i).to_a.map(&:join)
    end
  end

  # Remove duplicates from the phone number.
  def uniq_numbers
    @_uniq_numbers ||= phone.split(".").map {|s| [s.length.to_s, s.split("").uniq.sort]}.to_h
  end

  # Check for all validations
  def is_valid?
    updateToLog("Validating: Phone Number and File Path")
    validate_phone_number && validate_file
  end

  # Output prints
  def updateToLog(nlog)
    $stderr.puts(nlog) 
  end

  # Look for valid phone numbers
  def validate_phone_number
    return true if phone.nil? || phone.length <= 0 || (Float(phone) rescue false)
    return if updateToLog('Validation Failed: Not an valid phone number, e.g: 33.44 or 2255.63')
  end

  # Look for valid file 
  def validate_file
    return true if !file_path.nil? && File.exist?(file_path)
    return false if updateToLog('Validation Failed: No File Found')
  end

end