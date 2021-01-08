class CsvController
  require 'ruby-progressbar'
  require 'fastest-csv'
  require 'mysql2'

  def initialize(input_file)
    @client = ::Mysql2::Client.new(host: ENV['DB_HOST'], username: ENV['DB_USER'], password: ENV['DB_PASSWORD'])
    @client.query('SET CHARSET utf8mb4')
    @input_file = input_file
  end

  def import(db_name, table_name)
    drop_create_table(db_name, table_name)
    pb = ProgressBar.create(total: File.foreach(@input_file).inject(0) {|c, line| c+1}, progress_mark: '#', remainder_mark: '･')
    ::FastestCSV.foreach(@input_file) do |row|
      value = ''
      row.each do |str|
        value << ',' unless value.empty?
        value << convert(str)
      end
      @client.query("INSERT INTO #{db_name}.#{table_name} (row) values ('#{value}')")
      pb.increment
    end
    pb.finish
  end

  private

  def drop_create_table(db_name, table_name)
    @client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
    @client.query("DROP TABLE IF EXISTS #{db_name}.#{table_name}")
    @client.query("CREATE TABLE IF NOT EXISTS #{db_name}.#{table_name} (id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY, row TEXT)")
  end

  def convert(str)
    if !(str =~ /\A[0-9]+\z/).nil?
      str.gsub("'", '').strip
    else
      DateTime.parse(str.gsub("'", '').strip).to_s
    end
  rescue ArgumentError
    str.gsub("'", '').strip
  end
end
