require 'nkf'
require 'diff/lcs'

class Comparator
  def initialize(input_file_path1, input_file_path2)
    @input_file_path1 = input_file_path1
    @input_file_path2 = input_file_path2
  end

  def compare
    split1 = read(@input_file_path1).split(/$/)
    split2 = read(@input_file_path2).split(/$/)
    diffs = {}
    split1.length.times do |idx|
      str1 = idx < split1.size ? split1[idx] : ''
      str2 = idx < split2.size ? split2[idx] : ''
      if !(Diff::LCS.diff(str1, str2).empty?)
        diffs[idx] = { "#{@input_file_path1}": str1, "#{@input_file_path2}": str2 }
      end
    end
    diffs
  end

  def read(input_file_path)
    content = File.read(input_file_path)
    encode = NKF.guess(content)
    body = ''
    File.open(input_file_path, 'r') do |f|
      body = File.read(f, encoding: "BOM|#{encode}").encode(Encoding::UTF_8)
    end
    body
  end
end
