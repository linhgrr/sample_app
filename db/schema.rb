ActiveRecord::Schema[7.0].define(version: 2025_07_17_174536) do
  create_table "microposts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
