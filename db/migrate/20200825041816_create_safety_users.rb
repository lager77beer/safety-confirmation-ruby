class CreateSafetyUsers < ActiveRecord::Migration[5.2]
  def self.up
    execute <<-SQL
      CREATE VIEW safety_users AS SELECT
            s.id, s.disaster_id, s.user_id, u.name, u.email, s.myself, u.phone, s.updated_at
            FROM safeties AS s INNER JOIN users AS u ON (s.user_id = u.id)
    SQL
  end
  def self.down
    execute <<-SQL
      DROP VIEW safety_users
    SQL
  end
end
