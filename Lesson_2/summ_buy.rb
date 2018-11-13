basket = {}
sum = 0
loop do
  puts "Введите название товара или 'stop' для завершения"
  name_product = gets.chomp
  break if name_product == "stop"
  puts "Введите стоимость товара"
  price = gets.chomp.to_f
  puts "Введите количество товара"
  quantity = gets.chomp.to_f
  basket[name_product] = {:cost => price, :count => quantity, :price_total => price * quantity }
end
puts "Ваша корзина"
basket.each do |item_name, value|
  puts "#{item_name} цена за 1шт #{value[:cost]}\n Кол-во #{value[:count]} - всего #{value[:price_total]}"
  sum+= value[:price_total]
end
puts "Итог: #{sum}"
