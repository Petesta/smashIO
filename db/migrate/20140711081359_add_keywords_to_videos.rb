class AddKeywordsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :keywords, :string
  end
end
