puts "Введи значение а"
a = gets.chomp.to_f
puts "Введи значение b"
b = gets.chomp.to_f
puts "Введи значение c"
c = gets.chomp.to_f
d = b**2 - 4 * a * c
if d < 0
  puts "Дискриминант равен #{d}. Корней нет"
elsif d == 0
    x = (-b)/2 * a
    puts "Дискриминант равен #{d}. Корень один = #{x}"
else
  x_1 = (-b + Math.sqrt(d)) / 2 * a
  x_2 = (-b - Math.sqrt(d)) / 2 * a
  puts "Дискриминант равен #{d}, Корни: Х1 = #{x_1}, X2 = #{x_2}"
end
