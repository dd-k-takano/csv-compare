class CsvController
  require 'mysql2'
  require 'fastest-csv'

  def initialize(input_file)
    @client = ::Mysql2::Client.new(host: ENV['DB_HOST'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])
    @client.query('SET CHARSET utf8mb4')
    @input_file = input_file
  end

  def import
    db_name = @input_file.split('/')[2]
    table_name = @input_file.split('/')[3]
    drop_create_table(db_name, table_name)
    ::FastestCSV.foreach(@input_file) do |row|
      value = ''
      row.each do |str|
        value << ',' if value.size != 0
        value << str.gsub("'", '')
      end
      @client.query("INSERT INTO #{db_name}.#{table_name} (row) values ('#{value}')")
    end
  end

  private

  def drop_create_table(db_name, table_name)
    @client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
    @client.query("DROP TABLE IF EXISTS #{db_name}.#{table_name}")
    @client.query("CREATE TABLE IF NOT EXISTS #{db_name}.#{table_name} (id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY, row TEXT)")
  end
end
