# Ruby Project: Advanced Building Blocks
Two small projects to learn Ruby fundamentals: Bubble Sort, and Enumerable Methods.

These projects focus on the idea of using blocks and procs, and each project includes additional helper methods and run-time code to test the various methods with various conditions and input/parameters.

This is another exercise in The Odin Project, the specific instructions for which can be found at:

https://www.theodinproject.com/courses/ruby-programming/lessons/advanced-building-blocks?ref=lnav


## Bubble Sort

### "bubble_sort"
A method that uses the "bubble sort" algorithm to sort any array containing like-items that can be compared to one another (ie: as greater-than, equal-to, and less-than).  All elements in the array must be the same object type. (Numbers, Strings...).

Strings are compared by ASCII code and length, according to the inherent comparison operators for Ruby.  The left-most ASCII character is compared first, with the lower value character being sorted first.  In the even of a tie, the comparison of characters moves from left to right.  Words having a lower value first character will be considered "less than" a shorter word that has a higher value first character, and thus sorted first.

### "bubble_sort_by"
A variation of the bubble_sort method above.  Most of the code is actually the same. However, Bubble_sort_by accepts a block to determine the sorting criteria between the two elements being compared (originally, it was swap if array[i-1] > array[i]).
Now, for example, you could pass the block {|left, right| left.length > right.length} to swap the two elements if the left element is larger than the right element.

## Enumerable Methods
A collection of methods, wrapped in a module called "MyEnumerable."  This is a recreation of some of the most common methods available from the Enumerable class:

each, each_with_index, select, all?, any?, none?, count, map, and inject.

Note: map has been recreated in three versions, with various ways to pass the block/proc into the method (my_map, my_map_proc, and my_map_proc_or_block)

Each implementation handles passing in a block as a parameter, as well as the case when no block is passed.

File my_enumerable_test.rb is a separate script that can also be used to test the methods in the MyEnumerable module.  It includes the same test code found at the bottom of my_enumerable.rb.
