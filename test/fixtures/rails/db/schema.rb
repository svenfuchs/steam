ActiveRecord::Schema.define(:version => 20090926101010) do
  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
