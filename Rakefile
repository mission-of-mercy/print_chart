require_relative 'lib/print_chart'
require 'resque/tasks'

task :update_printers do
  PrintChart.update_printers!
end

task :console do
  exec "irb -I lib -r print_chart"
end
