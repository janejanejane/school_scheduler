class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
    	t.integer :teacher_id
    	t.integer :lecture_session_id
    	t.string :frequency
    	t.time :start_time
    	t.integer :time_interval

      t.timestamps
    end

    add_index :schedules, :teacher_id
    add_index :schedules, :lecture_session_id
  end
end
