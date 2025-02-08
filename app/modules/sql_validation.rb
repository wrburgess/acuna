module SqlValidation
  def self.read_only?(sql:)
    mutation_commands = %w[
      alter
      backup
      create
      delete
      drop
      insert
      into
      truncate
      update
      values
    ]

    readonly_commands = [ "select" ]
    sql_downcased = sql.downcase.strip

    # reject empty statements
    return false if sql_downcased.length == 0

    # reject multiple statements
    return false if sql_downcased.split(";").length > 1

    # reject mutative commands
    return false if mutation_commands.any? { |command| sql_downcased.include? command }

    # require readonly commands
    return true if readonly_commands.any? { |command| sql_downcased.include? command }

    # require SELECT statement
    return false unless sql_downcased.include? "select"

    false
  end
end
