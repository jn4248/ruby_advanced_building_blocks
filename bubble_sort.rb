# Sorts any array containing like-items that can be compared to one another
# (as greater-than, equal-to, and less-than), using the "bubble sort" algorithm.
# All elements in the array must be the same object type. (Numbers, Strings...).
# Strings are compared by ASCII code and length.
# Parameter: Array
# Returns:   Sorted Array
#
def bubble_sort(arr)
  still_swapping = true
  while still_swapping
    num_swaps = 0
    arr.each_with_index do |item, index|
      unless index == 0
        if arr[index - 1] > item
           arr[index -1], arr[index] = arr[index], arr[index - 1]
           num_swaps += 1
        end
      end
    end
    still_swapping = false if num_swaps == 0
  end
  return arr
end

# A variation of the bubble_sort method.  Bubble_sort_by accept a block as
# a parameter to determine the sorting criteria between the two elements
# being compared (originally, it was swap if array[i-1] > array[i]).
# Parameters: Array (and block)
# Returns:    Sorted Array
def bubble_sort_by(arr)
  still_swapping = true
  while still_swapping
    num_swaps = 0
    arr.each_with_index do |item, index|
      unless index == 0
        if yield(arr[index -1], arr[index]) > 0
           arr[index -1], arr[index] = arr[index], arr[index - 1]
           num_swaps += 1
        end
      end
    end
    still_swapping = false if num_swaps == 0
  end
  return arr
end


#Test method for bubble_sort()
def test_bubble_sort(test_array, expected, note="")
  puts "\nTesting Array:"
  p test_array
  puts "\n#{note}\n " if note.length > 0
  puts "Exptected Result:"
  p expected
  puts "bubble_sort result:"
  p bubble_sort(test_array)
  puts "====================================="
end


#
#Test Code for bubble_sort()
#
my_array = [1,2,3,4,5]
expected = [1,2,3,4,5]
test_bubble_sort(my_array, expected)

my_array = [5,4,3,2,1]
expected = [1,2,3,4,5]
test_bubble_sort(my_array, expected)

my_array = [5,2,4,4,3,1]
expected = [1,2,3,4,4,5]
test_bubble_sort(my_array, expected)

my_array = [4,4,2,5,3,1]
expected = [1,2,3,4,4,5]
test_bubble_sort(my_array, expected)

my_array = [4,2,5,3,1,1]
expected = [1,1,2,3,4,5]
test_bubble_sort(my_array, expected)

my_array = [1,1,1,1,1]
expected = [1,1,1,1,1]
test_bubble_sort(my_array, expected)

my_array = [1,8,0,-4,2,-3]
expected = [-4,-3,0,1,2,8]
test_bubble_sort(my_array, expected)

my_array = [7]
expected = [7]
test_bubble_sort(my_array, expected)

my_array = [0]
expected = [0]
test_bubble_sort(my_array, expected)

my_array = [-4,-8,-1,-5,-6]
expected = [-8,-6,-5,-4,-1]
test_bubble_sort(my_array, expected)

my_array = %w{r a d i z e}
expected = %w{a d e i r z}
test_bubble_sort(my_array, expected)

my_array = %w{D A K O E}
expected = %w{A D E K O}
test_bubble_sort(my_array, expected)

my_array = %w{k D M c}
expected = %w{D M c k}
note = "ASCII codes for uppercase are \"lesser than\" lowercase"
test_bubble_sort(my_array, expected, note)

my_array = %w{C ~ d & ^ B w}
expected = %w{& B C ^ d w ~}
note = "ASCII codes: &=38, B=66, C=67, ^=94, d=100, w=119, ~=126}"
test_bubble_sort(my_array, expected, note)

my_array = %w{Ron Jim jim Ronny JIM ron Jimmy RON jimmy ronny}
expected = %w{JIM Jim Jimmy RON Ron Ronny jim jimmy ron ronny}
note = "The left-most ASCII characters are compared first, then left to right.  A word with a 'lower' first ASCII character is considered \"less than\" a shorter word that has a 'higher' first character with shorter lengt."
test_bubble_sort(my_array, expected, note)

my_array = %w{tim TIM Tim TIM}
expected = %w{TIM TIM Tim tim}
test_bubble_sort(my_array, expected)

my_array = %w{d 33 e 3 ee 45 E 44 DD Ed 34 ED EE 4 D}
expected = %w{3 33 34 4 44 45 D DD E ED EE Ed d e ee}
note = "Numbers can be compared if they are string representations. ASCII codes: \"3\"=51, \"4\"=52, \"I\"=73, \"J\"=74, \"i\"=105, \"j\"=106"
test_bubble_sort(my_array, expected)


#
# Test code for bubble_sort_by
#
my_array = %w{hi hello hey}
puts "\nTesting bubble_sort-by, using array:"
p my_array
puts "Expecting:"
p %w{hi hey hello}
puts "Resulting array:"
sorted_array = bubble_sort_by(my_array) do |left,right|
  left.length - right.length
end
p sorted_array
puts "_____________________________________"

my_array = %w{hi hello hi hey}
puts "\nTesting bubble_sort-by, using array:"
p my_array
puts "Expecting:"
p %w{hi hi hey hello}
puts "Resulting array:"
sorted_array = bubble_sort_by(my_array) do |left,right|
  left.length - right.length
end
p sorted_array
puts "_____________________________________"

my_array = %w{hi hello hey}
puts "\nTesting bubble_sort-by, using array:"
p my_array
puts "Expecting:"
p %w{hello hey hi}
puts "Resulting array:"
sorted_array = bubble_sort_by(my_array) do |left,right|
  right.length - left.length
end
p sorted_array
puts "_____________________________________"
