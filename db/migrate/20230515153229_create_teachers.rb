class CreateTeachers < ActiveRecord::Migration[7.1]
  def change
    create_table :teachers do |t|
      t.string :employee_card_number
      t.string :integer
      t.string :first_name
      t.string :string
      t.string :last_name
      t.integer :years_of_experience

      t.timestamps
    end
  end
end
