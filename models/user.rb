class User
  def self.login(username)
    user = db.execute("SELECT * FROM users WHERE username = ?", username).first
    return user
  end

  def self.register(username, password)
    user = db.execute("SELECT * FROM users WHERE username = ?", username).first
    if user
      return true
    else
      db.execute("INSERT INTO users (username, password) VALUES (?, ?)", [username, password])
      return false
    end
  end
end