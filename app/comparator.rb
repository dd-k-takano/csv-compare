class Comparator
  require 'ruby-progressbar'
  require 'mysql2'

  def initialize(bq_tables, td_tables)
    @client = ::Mysql2::Client.new(host: ENV['DB_HOST'], username: ENV['DB_USER'], password: ENV['DB_PASSWORD'])
    @client.query('SET CHARSET utf8mb4')
    @bq_tables = bq_tables
    @td_tables = td_tables
  end

  def compare(db_name, table_name)
    drop_create_table(db_name, table_name)
    bq_data = @client.query(_query(@bq_tables))
    pb = ProgressBar.create(total: bq_data.count, progress_mark: '=', remainder_mark: '･')
    bq_data.each do |row|
      select_from_td_rows = @client.query("#{_query(@td_tables)} WHERE row = '#{row['row']}'").each
      @client.query("INSERT INTO #{db_name}.#{table_name} (id, row) values (#{row['id']}, '#{row['row']}')") if select_from_td_rows.empty?
      pb.increment
    end
    pb.finish
  end

  private

  def drop_create_table(db_name, table_name)
    @client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
    @client.query("DROP TABLE IF EXISTS #{db_name}.#{table_name}")
    @client.query("CREATE TABLE IF NOT EXISTS #{db_name}.#{table_name} (id BIGINT, row TEXT)")
  end

  def _query(tables)
    sql = ''
    tables.each do |table_name|
      sql << ' UNION ALL ' unless sql.empty?
      sql << "SELECT * FROM #{table_name}"
    end
    sql
  end
end
