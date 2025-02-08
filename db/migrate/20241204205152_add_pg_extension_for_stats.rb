class AddPgExtensionForStats < ActiveRecord::Migration[8.0]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";'
  end
end
