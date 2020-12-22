class Sorter
  def sort(input_file, output_file)
    File.open input_file do |i_file|
      File.open output_file, 'w' do |o_file|
        o_file.puts i_file.read.split("\n").sort
      end
    end
  end
end
