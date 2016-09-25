#! /usr/bin/ruby

require_relative 'driving_history_calculator'

input_lines = []

while input_line = gets
  input_lines << input_line.chomp
end

driving_history_calculator = DrivingHistoryCalculator.new(input_lines)

report_lines = driving_history_calculator.generate_report_lines()

report_lines.each {|line|
  puts line
}