require 'fileutils'
require 'logger'
require './app/comparator'
require './app/sorter'

def glob(target_dir)
  file_list = []
  Dir.glob('**/*', base: target_dir).each do |file|
    file_path = File.join(target_dir, file)
    file_list.push(file_path) unless File.directory?(file_path)
  end
  file_list
end

glob('data').each do |file_path|
  sort_file_path = file_path.gsub(%r{^data/}, 'sort/')
  FileUtils.mkdir_p(File.dirname(sort_file_path)) unless File.exist?(File.dirname(sort_file_path))
  Sorter.new.sort(file_path, sort_file_path)
end

glob('sort/td').each do |sort_file_path|
  diffs = Comparator.new(sort_file_path, sort_file_path.gsub(%r{/td/}, '/bq/')).compare
  if !(diffs.keys.empty?)
    out_file_path = sort_file_path.gsub(%r{^sort/td/}, 'out/')
    FileUtils.mkdir_p(File.dirname(out_file_path)) unless File.exist?(File.dirname(out_file_path))
    body = ''
    diffs.keys.each do |lineno|
      filenames = diffs[lineno].keys
      body << "#{filenames[0]}(#{lineno}): #{diffs[lineno][filenames[0]].gsub(/^\n/, '')}\n"
      body << "#{filenames[1]}(#{lineno}): #{diffs[lineno][filenames[1]].gsub(/^\n/, '')}\n"
    end
    File.binwrite(out_file_path, body)
  end
end
