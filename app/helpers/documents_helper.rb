module DocumentsHelper

  def sort_by_first_value_number()
    #sort by first value, if number is the first value
    #converting to integers and comparing two items in the callback (sorting on them)
    array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
    #modify the existing array
    array_of_lines.uniq!(&:first)
    array_of_lines.each { |line| p line }
  end

end
