puts "Введите сторону А"
a = gets.chomp.to_f
puts "Введите сторону B"
b = gets.chomp.to_f
puts "Введите сторону C"
c = gets.chomp.to_f
hypotenuse = 0
if a > c
  hypotenuse = a
  side_B = b
  side_c = c
elsif c > b
  hypotenuse = c
  side_B = a
  side_c = b
else
  hypotenuse = b
  side_B = a
  side_c = c
end

if hypotenuse**2 == side_B**2 + side_c**2
  puts "Это прямоугольный треугольник"
elsif (a == b &&  b == c)
  puts "Равносторонний и равнобедренный треугольник"
elsif side_B == side_c
  puts "Равнобедренный"
end
