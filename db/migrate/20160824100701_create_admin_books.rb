class CreateAdminBooks < ActiveRecord::Migration
  def change
    create_table :admin_books do |t|
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
