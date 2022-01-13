# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :post, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :comments }

      t.timestamps
    end
  end
end
