class MakeCommentsPolymorphic < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :tweet_id, :integer  # 既存の `tweet_id` を削除
    add_reference :comments, :commentable, polymorphic: true, index: true  # ポリモーフィック対応
  end
end