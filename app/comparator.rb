class Comparator
  require 'mysql2'

  def initialize(bq_tables, td_tables)
    @client = ::Mysql2::Client.new(host: ENV['DB_HOST'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])
    @client.query('SET CHARSET utf8mb4')
    @bq_tables = bq_tables
    @td_tables = td_tables
  end

  def compare
    select_from_bq_sql = _query(@bq_tables)
    select_from_td_sql = _query(@td_tables)
    @client.query(select_from_bq_sql).each do |row|
      pp @client.query("#{select_from_td_sql} WHERE row = '#{row[:row]}'")
    end
  end

  def _query(tables)
    sql = ''
  end
end
