require 'fileutils'
require 'logger'
require './app/comparator'
require './app/csv_controller'

def glob(target_dir)
  file_list = []
  Dir.glob('**/*', base: target_dir).each do |file|
    file_path = File.join(target_dir, file)
    file_list.push(file_path) unless File.directory?(file_path)
  end
  file_list
end

glob('/data').each do |file_path|
  puts "------------- #{file_path} -------------"
  CsvController.new(file_path).import
end

# [
#   { bq: [], td: [] }
# ].each do |target|
#   Comparator.new(target[:bq], target[:td]).compare
# end
