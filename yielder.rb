def perform(*a, &block)
  if block
    p block.call(a)
  end
  a.first
end

p perform('a')
p perform('a') { |a| a.first * 3 }



def total(from, to, &block)
  result = 0
  from.upto(to) do |num|
    if block
      result += block.call(num)
    else
      result += num
    end
  end
  return result
end

p total(1, 3)
p total(1, 3) { |n| n + 1 }
