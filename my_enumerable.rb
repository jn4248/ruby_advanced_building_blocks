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
