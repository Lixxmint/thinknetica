puts "Введите число"
day = gets.chomp.to_i
puts "Введите месяц"
mounth = gets.chomp.to_i
puts "Введите год"
year = gets.chomp.to_i
all_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30 , 31]
if year % 4 == 0 && year % 100 == 0
  all_day[1] = 29
end
puts all_day.take(mounth - 1).sum + day
