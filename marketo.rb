#!/usr/bin/env ruby

# This assumes constraint on the combination of id and name being unique

# mysql> create database testdb;
# mysql> GRANT ALL PRIVILEGES ON testdb.* TO 'user'@'localhost' IDENTIFIED BY 'passwd';
# mysql> CREATE TABLE NAMES (id INTEGER NOT NULL, name CHAR(100) NOT NULL, value CHAR(100) NOT NULL, timestamp TIMESTAMP, PRIMARY KEY(id), UNIQUE(id, name));

require 'rubygems'
require 'mysql'
require 'json'
require 'open-uri'

class Marketo

  def initialize(url)
    @names = JSON.parse open(url).read
  end

  def update
    db = Mysql.new('localhost', 'user', 'passwd', 'testdb')
    @names.each do |name|
      db.query "REPLACE INTO names(name, id, value, timestamp) VALUES('#{name['name']}', #{name['id'].to_i}, '#{name['value']}', '#{name['timestamp']}')"
    end
  end

end

marketo = Marketo.new ARGV[0]
marketo.update
