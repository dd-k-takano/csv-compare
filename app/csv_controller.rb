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
    cnt = _count
    if 0 < cnt
      @client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
      @client.query("CREATE TABLE IF NOT EXISTS #{db_name}.#{table_name} (id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY, #{columns(cnt)})")
      @client.query("LOAD DATA LOCAL INFILE \"#{@input_file}\" INTO TABLE  #{db_name}.#{table_name} FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ESCAPED BY '\"' (#{fields(cnt)}) SET #{mapping(cnt)} ")
    end
  end

  def _count
    ::FastestCSV.foreach(@input_file) do |row|
      return row.length
    end
    return 0
  end

  def columns(cnt)
    value = ''
    cnt.times do |idx|
      value << ',' unless value.empty?
      value << "col#{idx} TEXT"
    end
    return value
  end

  def fields(cnt)
    value = ''
    cnt.times do |idx|
      value << ',' unless value.empty?
      value << "@#{idx}"
    end
    return value
  end

  def mapping(cnt)
    value = ''
    cnt.times do |idx|
      value << ',' unless value.empty?
      value << "col#{idx}=@#{idx}"
    end
    return value
  end
end
