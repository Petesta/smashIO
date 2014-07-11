class AddCategoriesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :term, :string
    add_column :videos, :label, :string
  end
end
