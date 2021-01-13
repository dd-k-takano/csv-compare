require 'fileutils'
require 'fastest-csv'
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
  puts "--------------- #{file_path} ---------------"
  db = { db: file_path.split('/')[2], table: file_path.split('/')[3] }
  CsvController.new(file_path).import(db[:db], db[:table])
end

glob('/targets').each do |file_path|
  puts "--------------- #{file_path} ---------------"
  Comparator.new(file_path).compare('compare')
end
