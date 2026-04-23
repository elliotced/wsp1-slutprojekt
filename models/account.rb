class Account
  
  # Finds the account with the name
  # 
  # @param name [String] name of the account
  # @return [Hash, nil] account matching the name, or nil if not found
  def self.find(name)
    account = db.execute("SELECT * FROM accounts WHERE name = ?", name).first
    return account
  end

  # Creates a new account with a name password and type
  # 
  # @param name [String] name of the account
  # @param password [String] encrypted password
  # @param type [String] type for the account
  # @return [void]
  def self.register(name, password, type)

    db.execute("INSERT INTO accounts (name, password, type) VALUES (?, ?, ?)", [name, password, type])
  end

  
  # Deletes the account with the id
  # 
  # @param id [Integer] id of the account
  # @return [void]
  def self.delete(id)
    db.execute("DELETE FROM accounts WHERE id=?", id).first
  end
end