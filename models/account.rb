class Account
  def self.find(name)
    account = db.execute("SELECT * FROM accounts WHERE name = ?", name).first
    return account
  end

  def self.register(name, password, type)
    db.execute("INSERT INTO accounts (name, password, type) VALUES (?, ?, ?)", [name, password, type])
  end
end