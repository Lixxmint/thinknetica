puts "Введите сторону А"
a = gets.chomp.to_f
puts "Введите сторону B"
b = gets.chomp.to_f
puts "Введите сторону C"
c = gets.chomp.to_f
if a > b && a > c
  hypotenuse = a
  side_a = b
  side_b = c
elsif b > a && b > c
  hypotenuse = b
  side_a = a
  side_b = c
else
  hypotenuse = c
  side_a = a
  side_b = b
end
if hypotenuse**2 == side_a**2 + side_b**2
  puts "Это прямоугольный треугольник"
elsif (a == b &&  b == c && a == c)
  puts "Равносторонний и равнобедренный треугольник"
elsif (a == b) || (a == c) || (c == b)
  puts "Равнобедренный треугольник"
else
  puts "Это самы простый треугольник"
end
