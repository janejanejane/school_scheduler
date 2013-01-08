class AddPasswordDigestToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :password_digest, :string
  end
end
