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

targets = {}
glob('/list').each do |file_path|
  key = file_path.split('/')[2].gsub(/\.csv$/i, '')
  list = []
  ::FastestCSV.foreach(file_path) do |row|
    list.push(row)
  end
  targets[key] = list
end

targets[targets.keys[0]].each_with_index do |target, idx|
  puts "--------------- #{idx} : #{target} ---------------"
  Comparator.new(target, targets[targets.keys[1]][idx]).compare('diff', target[0].split('.')[1])
end
