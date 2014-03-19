class AddFuzzysearchSupport < ActiveRecord::Migration
  def up
    execute "create extension if not exists fuzzystrmatch"
    execute "create extension if not exists pg_trgm"
  end

  def down
  end
end
