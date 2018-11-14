alphabet = "a".."z"
vowels = [ "a", "e", "i", "o", "u" ]
vowels_hash = {}

alphabet.each_with_index { |item, index|
  vowels_hash[index + 1] = item if vowels.include?(item)
}
puts "#{vowels_hash}"
