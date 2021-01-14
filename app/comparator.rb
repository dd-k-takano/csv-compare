class Comparator
  require 'ruby-progressbar'
  require 'mysql2'

  def initialize(input_file)
    @client = ::Mysql2::Client.new(host: ENV['DB_HOST'], username: ENV['DB_USER'], password: ENV['DB_PASSWORD'])
    @client.query('SET CHARSET utf8mb4')
    @input_file = input_file
  end

  def compare(db_name)
    @client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
    @client.query("USE #{db_name}")
    @client.query("SOURCE #{@input_file}")
  end
end
