ActiveRecord::Schema[7.0].define(version: 2025_07_21_092502) do
  create_table "microposts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.date "birthday"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
