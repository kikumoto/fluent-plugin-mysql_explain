module Fluent
  class MysqlExplainFilter < Filter
    Plugin.register_filter('mysql_explain', self)

    def initialize
      super
      require "mysql2"
    end

    config_param :sql_key, :string, :default => 'sql'
    config_param :added_key, :string, :default => 'explain'

    config_param :host, :string
    config_param :port, :integer, :default => nil
    config_param :database, :string
    config_param :username, :string
    config_param :password, :string, :default => '', :secret => true

    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      sql = hash_get(record, @sql_key)
      if !sql.nil? && !sql.empty?
        record[@added_key] = explain(sql)
      end
      record
    end

    def explain(sql)
      if sql.empty? || !explainable?(sql)
        return ''
      end

      res = StringIO.new

      handler = self.client
      handler.query("EXPLAIN #{sql}").each_with_index do |row, i|
        res.puts "*************************** #{i+1}. row ***************************"
        row.each do |key, value|
          value ||= "NULL"
          res.puts key.rjust(13, ' ') + ": #{value}"
        end
      end
      handler.close

      res.rewind
      res.read
    end

    def explainable?(sql)
      sql =~/^\s*(SELECT|DELETE|INSERT|REPLACE|UPDATE)/i
    end

    def hash_get(hash, key)
      return hash[key.to_sym] if hash.key?(key.to_sym)
      return hash[key] if hash.key?(key)
      nil
    end

    def client
      Mysql2::Client.new({
          :host => @host, :port => @port,
          :username => @username, :password => @password,
          :database => @database, :flags => Mysql2::Client::MULTI_STATEMENTS,
      })
    end 
  end
end
