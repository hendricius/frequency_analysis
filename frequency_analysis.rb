class FrequencyAnalysis

  attr_accessor :text, :letter_frequencies, :analysis

  def initialize(text, letter_frequencies = nil)
    @text = text
    @letter_frequencies = letter_frequencies ? letter_frequencies : self.class.german_letter_frequency
    @analysis = analyze_text
  end

  # German letter frequency in percent
  def self.german_letter_frequency
    {
      a: 6.51,
      b: 1.89,
      c: 3.06,
      d: 5.08,
      e: 17.4,
      f: 1.66,
      g: 3.01,
      h: 4.76,
      i: 7.55,
      j: 0.27,
      k: 1.21,
      l: 3.44,
      m: 2.53,
      n: 9.78,
      o: 2.51,
      p: 0.79,
      q: 0.02,
      r: 7,
      s: 7.27,
      t: 6.15,
      u: 4.35,
      v: 0.67,
      w: 1.89,
      x: 0.03,
      y: 0.04,
      z: 1.13
    }
  end

  def analyze_text
    alphabet_sorted = get_alphabet_sorted
    text_sorted = get_character_percentages
    pairs = []
    text_sorted.keys.each_with_index do |letter, index|
      pairs.push [letter.to_s, alphabet_sorted.keys[index].to_s]
    end
    self.analysis = Hash[pairs]
    analysis
  end

  def replace_character(character, new_value)
    return unless character && new_value
    new_analysis = Marshal.load(Marshal.dump(analysis))
    new_analysis[character] = new_value
    self.analysis = Marshal.load(Marshal.dump(new_analysis))
  end

  def replace_decyphe(character, new_value)
    replace_character(character, new_value)
    decypher_text
  end

  def pretty_print_analysis
    analyze_text.each do |key,val|
      puts "#{key} is likely: #{val}"
    end
    nil
  end

  def decypher_text
    final_text = ""
    text.split("").each do |letter|
      final_text += analysis[letter].to_s
    end
    final_text
  end

  def get_alphabet_sorted
    Hash[letter_frequencies.sort_by{|k,v| v}.reverse]
  end

  def get_character_percentages
    percents = get_character_lengths.map do |letter, frequency|
      percent = (frequency.to_f / text.length.to_f) * 100
      [letter, percent]
    end
    percents = Hash[percents]
    Hash[percents.sort_by{|k,v| v}.reverse]
  end

  def get_character_lengths
    letter_list = empty_character_list
    text.split("").each do |letter|
      letter_list[letter.to_sym].push(letter)
    end
    letter_list.each do |letter, text_letter_arr|
      letter_list[letter] = text_letter_arr.length
    end
    letter_list
  end

  def empty_character_list
    {
      a: [],
      b: [],
      c: [],
      d: [],
      e: [],
      f: [],
      g: [],
      h: [],
      i: [],
      j: [],
      k: [],
      l: [],
      m: [],
      n: [],
      o: [],
      p: [],
      q: [],
      r: [],
      s: [],
      t: [],
      u: [],
      v: [],
      w: [],
      x: [],
      y: [],
      z: []
    }
  end
end
