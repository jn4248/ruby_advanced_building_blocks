module MyEnumerable

  def MyEnumerable.my_each(array)
    for element in array
      if block_given?
        yield(element)
      end
    end
    return block_given? ? array : array.to_enum(:my_each)
  end

  def MyEnumerable.my_each_with_index(array)
    count = 0
    for element in array
      if block_given?
        yield(element, count)
      end
      count += 1
    end
    return block_given? ? array : array.to_enum(:my_each_with_index)
  end

  def MyEnumerable.my_select(array)
    new_array = []
    for element in array
      if block_given?
        if yield(element)
          new_array.push(element)
        end
      else
        new_array.push(element)
      end
    end
    return block_given? ? new_array : new_array.to_enum(:my_select)
  end

  def MyEnumerable.my_all?(array)
    all_items_match = true
    for element in array
      if block_given?
        if !yield(element)
          all_items_match = false
          break
        end
      elsif !element
        # fails if any members are either "nil" or "false"
        all_items_match = false
        break
      end
    end
    all_items_match
  end

  def MyEnumerable.my_any?(array)
    item_match = false
    for element in array
      if block_given?
        if yield(element)
          item_match = true
          break
        end
        # elsif element != nil && element != false
      elsif element
        # true if at least one member is neither "nil" nor "false"
        item_match = true
        break
      end
    end
    item_match ? true : false
  end

  def MyEnumerable.my_none?(array)
    no_match = true
    for element in array
      if block_given?
        if yield(element)
          no_match = false
        end
      elsif element
        # all elements must return "true"
        no_match = false
        break
      end
    end
    no_match
  end

  def MyEnumerable.my_count(array)
    count = 0
    for element in array
      # count the matches if block is given
      if block_given?
        if yield(element)
          count += 1
        end
      else
        # if no block, simply count the number of elements
        count += 1
      end
    end
    count
  end

  # version 1: Executes with or without a block (procs not addressed here)
  def MyEnumerable.my_map(array)
    new_array = []
    for element in array
      if block_given?
        new_array.push(yield(element))
      end
    end
    return block_given? ? new_array : array.to_enum(:my_map)
  end

  # version 2: requires a proc passed as a parameter.
  def MyEnumerable.my_map_proc(array, proc)
    new_array = []
    for element in array
      new_array.push(proc.call element)
    end
    return new_array
  end

  # version 3: accepts a proc, block, or neither.
  # If both a proc and block are given, the proc is used, and the block ignored
  def MyEnumerable.my_map_proc_or_block(array, proc = nil)
    new_array = []
    for element in array
      if proc != nil
        new_array.push(proc.call element)
      elsif block_given?
        new_array.push(yield(element))
      else
        new_array.push(element)
      end
    end
    if (block_given? || proc != nil)
      return new_array
    else
      return array.to_enum(:my_map_proc_or_block)
    end
  end

  # enumerator "inject" throws an exception if no block is passed.
  # Therefore, no clause is included here for such a case.
  # This version does not accept symbols to define the block method or operator
  def MyEnumerable.my_inject(array, initial_value = nil)
    # if initial_value not passed in, assign first element in collection
    memo = (initial_value == nil) ? array[0] : initial_value
    count = 0
    for element in array
      # if no initial value passed in, assign first iteration value to be memo
      unless initial_value == nil && count == 0
        memo = (yield(memo, element))
      end
      count += 1
    end
    return memo
  end

  # extra method requested, using my_inject strictly to multiply all elements
  def MyEnumerable.multiply_els(array)
    my_inject(array, 1) {|product, element| product * element}
  end

end






# Test code arrays to be used below
a=[1,2,3,4,5]
b=["hi", "hello", "hey", "byebye"]
c = [nil]
d = [false]
e = []

# Test code for each method in module "MyEnumberable"
# Each section tests a single method againsts it's matching method from class
# Enumerable.  Tests use the above arrays (a - e), and check both cases when
# a block is supplied, and when a block is not supplied.
#
# (my_map_proc_or_block() is the only method configured to accept both procs
# and blocks. Therefore, test cases include proc only, block only, both proc and
# block, as well as neither proc nor block)

puts "Testing my_each() / each() (each set of 2 results should match)\n "
p MyEnumerable.my_each(a) {|item| puts item * 2}
p a.each() {|item| puts item * 2}
puts "____________________________________________"
p MyEnumerable.my_each(b) {|item| puts item}
p b.each() {|item| puts item}
puts "____________________________________________"
p MyEnumerable.my_each(b)
p b.each()
puts "____________________________________________"
p MyEnumerable.my_each(c)
p c.each()
puts "____________________________________________"
p MyEnumerable.my_each(d)
p d.each()
puts "____________________________________________"
p MyEnumerable.my_each(e)
p e.each()
puts "=====================================================================\n\n "


puts "Testing my_each_with_index() / each_with_index() (each set of 2 results should match)\n "
p MyEnumerable.my_each_with_index(a) {|item, index| puts "#{item * 2} at index #{index}"}
p a.each_with_index() {|item, index| puts "#{item * 2} at index #{index}"}
puts "____________________________________________"
p MyEnumerable.my_each_with_index(b) {|item, index| puts "'#{item}' at index #{index}"}
p b.each_with_index() {|item, index| puts "'#{item}' at index #{index}"}
puts "____________________________________________"
p MyEnumerable.my_each_with_index(b)
p b.each_with_index()
puts "____________________________________________"
p MyEnumerable.my_each_with_index(c)
p c.each_with_index()
puts "____________________________________________"
p MyEnumerable.my_each_with_index(d)
p d.each_with_index()
puts "____________________________________________"
p MyEnumerable.my_each_with_index(e)
p e.each_with_index()
puts "=====================================================================\n\n "


puts "Testing my_select() / select() (each set of 2 results should match)\n "
p MyEnumerable.my_select(a) {|item| item % 2 == 1}
p a.select() {|item| item % 2 == 1}
puts "____________________________________________"
p MyEnumerable.my_select(b) {|item| item.length < 5}
p b.select() {|item| item.length < 5}
puts "____________________________________________"
p MyEnumerable.my_select(b)
p b.select()
puts "____________________________________________"
p MyEnumerable.my_select(c)
p c.select()
puts "____________________________________________"
p MyEnumerable.my_select(d)
p d.select()
puts "____________________________________________"
p MyEnumerable.my_select(e)
p e.select()
puts "=====================================================================\n\n "


puts "Testing my_all?() / all?() (each set of 2 results should match)\n "
p MyEnumerable.my_all?(a) {|item| item < 6}
p a.all?() {|item| item < 6}
puts "____________________________________________"
p MyEnumerable.my_all?(a) {|item| item < 5}
p a.all?() {|item| item < 5}
puts "____________________________________________"
p MyEnumerable.my_all?(b) {|item| item.length < 5}
p b.all?() {|item| item.length < 5}
puts "____________________________________________"
p MyEnumerable.my_all?(b) {|item| item.length < 10}
p b.all?() {|item| item.length < 10}
puts "____________________________________________"
p MyEnumerable.my_all?(b)
p b.all?()
puts "____________________________________________"
p MyEnumerable.my_all?(c)
p c.all?()
puts "____________________________________________"
p MyEnumerable.my_all?(d)
p d.all?()
puts "____________________________________________"
p MyEnumerable.my_all?(e)
p e.all?()
puts "=====================================================================\n\n "


puts "Testing my_any?() / any?() (each set of 2 results should match)\n "
p MyEnumerable.my_any?(a) {|item| item > 6}
p a.any?() {|item| item > 6}
puts "____________________________________________"
p MyEnumerable.my_any?(a) {|item| item > 4}
p a.any?() {|item| item > 4}
puts "____________________________________________"
p MyEnumerable.my_any?(b) {|item| item.length > 5}
p b.any?() {|item| item.length > 5}
puts "____________________________________________"
p MyEnumerable.my_any?(b) {|item| item.length > 10}
p b.any?() {|item| item.length > 10}
puts "____________________________________________"
p MyEnumerable.my_any?(b)
p b.any?()
puts "____________________________________________"
p MyEnumerable.my_any?(c)
p c.any?()
puts "____________________________________________"
p MyEnumerable.my_any?(d)
p d.any?()
puts "____________________________________________"
p MyEnumerable.my_any?(e)
p e.any?()
puts "=====================================================================\n\n "


puts "Testing my_none?() / none?() (each set of 2 results should match)\n "
p MyEnumerable.my_none?(a) {|item| item > 6}
p a.none?() {|item| item > 6}
puts "____________________________________________"
p MyEnumerable.my_none?(a) {|item| item > 4}
p a.none?() {|item| item > 4}
puts "____________________________________________"
p MyEnumerable.my_none?(b) {|item| item == "truck"}
p b.none?() {|item| item == "truck"}
puts "____________________________________________"
p MyEnumerable.my_none?(b) {|item| item == "hello"}
p b.none?() {|item| item == "hello"}
puts "____________________________________________"
p MyEnumerable.my_none?(b)
p b.none?()
puts "____________________________________________"
p MyEnumerable.my_none?(c)
p c.none?()
puts "____________________________________________"
p MyEnumerable.my_none?(d)
p d.none?()
puts "____________________________________________"
p MyEnumerable.my_none?(e)
p e.none?()
puts "=====================================================================\n\n "


puts "Testing my_count() / count() (each set of 2 results should match)\n "
p MyEnumerable.my_count(a) {|item| item > 6}
p a.count() {|item| item > 6}
puts "____________________________________________"
p MyEnumerable.my_count(a) {|item| item > 4}
p a.count() {|item| item > 4}
puts "____________________________________________"
p MyEnumerable.my_count(b) {|item| item == "truck"}
p b.count() {|item| item == "truck"}
puts "____________________________________________"
p MyEnumerable.my_count(b) {|item| item == "hello"}
p b.count() {|item| item == "hello"}
puts "____________________________________________"
p MyEnumerable.my_count(b)
p b.count()
puts "____________________________________________"
p MyEnumerable.my_count(c)
p c.count()
puts "____________________________________________"
p MyEnumerable.my_count(d)
p d.count()
puts "____________________________________________"
p MyEnumerable.my_count(e)
p e.count()
puts "=====================================================================\n\n "


puts "Testing my_map() / map() (each set of 2 results should match)\n "
p MyEnumerable.my_map(a) {|item| item * 2}
p a.map() {|item| item * 2}
puts "____________________________________________"
p MyEnumerable.my_map(a) {|item| item.to_s}
p a.map() {|item| item.to_s}
puts "____________________________________________"
p MyEnumerable.my_map(b) {|item| item + " beautiful"}
p b.map() {|item| item + " beautiful"}
puts "____________________________________________"
p MyEnumerable.my_map(b) {|item| item.length}
p b.map() {|item| item.length}
puts "____________________________________________"
p MyEnumerable.my_map(b)
p b.map()
puts "____________________________________________"
p MyEnumerable.my_map(c)
p c.map()
puts "____________________________________________"
p MyEnumerable.my_map(d)
p d.map()
puts "____________________________________________"
p MyEnumerable.my_map(e)
p e.map()
puts "=====================================================================\n\n "


puts "Testing my_map_proc() / map() (each set of 2 results should match)\n "
my_proc = Proc.new {|item| item * 2}
p MyEnumerable.my_map_proc(a, my_proc)
p a.map() {|item| item * 2}
puts "____________________________________________"
my_proc = Proc.new {|item| item.to_s}
p MyEnumerable.my_map_proc(a, my_proc)
p a.map() {|item| item.to_s}
puts "____________________________________________"
my_proc = Proc.new {|item| item + " beautiful"}
p MyEnumerable.my_map_proc(b, my_proc)
p b.map() {|item| item + " beautiful"}
puts "____________________________________________"
my_proc = Proc.new {|item| item.length}
p MyEnumerable.my_map_proc(b, my_proc)
p b.map() {|item| item.length}
puts "=====================================================================\n\n "


puts "\nTesting my_map_proc_or_block() / map() (each set of 2 results should match)\n "
puts "Testing by passing only procs:\n "
my_proc = Proc.new {|item| item * 2}
p MyEnumerable.my_map_proc_or_block(a, my_proc)
p a.map() {|item| item * 2}
puts "____________________________________________"
my_proc = Proc.new {|item| item.to_s}
p MyEnumerable.my_map_proc_or_block(a, my_proc)
p a.map() {|item| item.to_s}
puts "____________________________________________"
my_proc = Proc.new {|item| item + " beautiful"}
p MyEnumerable.my_map_proc_or_block(b, my_proc)
p b.map() {|item| item + " beautiful"}
puts "____________________________________________"
my_proc = Proc.new {|item| item.length}
p MyEnumerable.my_map_proc_or_block(b, my_proc)
p b.map() {|item| item.length}
puts "____________________________________________"

puts "\nTesting by passing only blocks\n "
p MyEnumerable.my_map_proc_or_block(a) {|item| item * 2}
p a.map() {|item| item * 2}
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(a) {|item| item.to_s}
p a.map() {|item| item.to_s}
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(b) {|item| item + " beautiful"}
p b.map() {|item| item + " beautiful"}
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(b) {|item| item.length}
p b.map() {|item| item.length}
puts "____________________________________________"

puts "\nTesting by passing only procs and blocks:"
puts "Proc is different from block (proc should be used, and block ignored)\n "
my_proc = Proc.new {|item| item * 2}
p MyEnumerable.my_map_proc_or_block(a, my_proc) {|item| item * 3}
p a.map() {|item| item * 2}
puts "____________________________________________"
my_proc = Proc.new {|item| item.to_s}
p MyEnumerable.my_map_proc_or_block(a, my_proc) {|item| item.to_s + " NO!"}
p a.map() {|item| item.to_s}
puts "____________________________________________"
my_proc = Proc.new {|item| item + " beautiful"}
p MyEnumerable.my_map_proc_or_block(b, my_proc) {|item| item + " ugly"}
p b.map() {|item| item + " beautiful"}
puts "____________________________________________"
my_proc = Proc.new {|item| item.length}
p MyEnumerable.my_map_proc_or_block(b, my_proc) {|item| item.upcase}
p b.map() {|item| item.length}
puts "____________________________________________"


puts "\nTesting by passing neither proc nor block\n "
p MyEnumerable.my_map_proc_or_block(a)
p a.map()
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(b)
p b.map()
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(c)
p c.map()
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(d)
p d.map()
puts "____________________________________________"
p MyEnumerable.my_map_proc_or_block(e)
p e.map()
puts "=====================================================================\n\n "


puts "Testing my_inject() / inject() (each set of 2 results should match)\n "
p MyEnumerable.my_inject(a, 0) {|sum, n| sum + n}
p a.inject(0) {|sum, n| sum + n}
puts "____________________________________________"
p MyEnumerable.my_inject(a, -5) {|sum, n| sum + n}
p a.inject(-5) {|sum, n| sum + n}
puts "____________________________________________"
p MyEnumerable.my_inject(a) {|sum, n| sum + n}
p a.inject() {|sum, n| sum + n}
puts "____________________________________________"
p MyEnumerable.my_inject(a,0) {|product, n| product * n}
p a.inject(0) {|product, n| product * n}
puts "____________________________________________"
p MyEnumerable.my_inject(a, 1) {|product, n| product * n}
p a.inject(1) {|product, n| product * n}
puts "____________________________________________"
p MyEnumerable.my_inject(a, -2) {|product, n| product * n}
p a.inject(-2) {|product, n| product * n}
puts "____________________________________________"
p MyEnumerable.my_inject(a) {|product, n| product * n}
p a.inject() {|product, n| product * n}
puts "____________________________________________"
p MyEnumerable.my_inject(b, "") {|memo, word| memo.length > word.length ? memo : word}
p b.inject("") {|memo, word| memo.length > word.length ? memo : word}
puts "____________________________________________"
p MyEnumerable.my_inject(b, "") {|joined, word| joined + " " + word}
p b.inject("") {|joined, word| joined + " " + word}
puts "____________________________________________"
p MyEnumerable.my_inject(b) {|joined, word| joined + " " + word}
p b.inject() {|joined, word| joined + " " + word}
puts "=====================================================================\n\n "


puts "Testing multiply_els()\n "
puts "Expected: 40 (product of elements [2, 4, 5])"
result = MyEnumerable.multiply_els([2, 4, 5])
puts "Result: " + result.to_s
puts "=====================================================================\n\n "
