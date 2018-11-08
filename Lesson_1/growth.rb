# Задача №1 Идеальный вес
puts "Введите ваше Имя"
name = gets.chomp
puts "Введите ваш рост"
growth = gets.chomp.to_i
ideal_growth = growth - 110
if(ideal_growth < 0)
  puts "#{name}, ваш вес уже оптимальный"
else
  puts "#{name}, ваш идеальный вес #{ideal_growth}"
end
