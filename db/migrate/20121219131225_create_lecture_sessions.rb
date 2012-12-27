class CreateLectureSessions < ActiveRecord::Migration
  def change
    create_table :lecture_sessions do |t|
    	t.string :name

      t.timestamps
    end

    add_index :lecture_sessions, :name
  end
end
