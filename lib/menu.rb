require 'menu/version'

module Menu
  extend self

  def run(lines=ARGV)
    lines = $stdin.read.split("\n") if !$stdin.tty?
    prompt(lines)
    answer = ask
    puts parse_answer(lines, answer)
  end

  def prompt(lines)
    ljust_size = lines.size.to_s.size + 1
    lines.each_with_index {|obj,i|
      puts "#{i+1}.".ljust(ljust_size) + " " +obj
    }
    print "\nSpecify individual choices (4,7), range of choices (1-3)" +
      " or all choices (*).\nChoose: "
  end

  def ask
    $stdin.reopen '/dev/tty'
    $stdin.gets.chomp
  end

  def parse_answer(array, input)
    return array if input.strip == '*'
    result = []
    input.split(/\s*,\s*/).each do |e|
      if e[/(\d+)-(\d+)/]
        min, max = $1, $2
        slice_min = min.to_i - 1
        result.push(*array.slice(slice_min, max.to_i - min.to_i + 1))
      elsif e[/^(\d+)$/]
        index = $1.to_i - 1
        result.push(array[index]) if array[index]
      else
        abort("`#{e}' is an invalid choice.")
      end
    end
    result
  end

  def unic_run(lines=ARGV)
    lines = $stdin.read.split("\n") if !$stdin.tty?
    unic_prompt(lines)
    answer = ask
    puts unic_answer(lines, answer)
  end

  def unic_answer(array, input)
    if input[/(\d+)/]
      index = $1.to_i - 1
      return array[index] if array[index]
    else
      abort("`#{input}' is an invalid choice.")
    end
  end

  def unic_prompt(lines)
    ljust_size = lines.size.to_s.size + 1
    lines.each_with_index {|obj,i|
      puts "#{i+1}.".ljust(ljust_size) + " " +obj
    }
    print "\nSpecify your choice\nChoose: "
  end
end
