module DatabaseCommands

  def self.extended(klass)
     klass.class_eval { include DbSave }
  end

  def build_response(class_name,data_array)
    responses = []

    data_array.each do |response|
      responses << class_name.new(response)
    end

    responses
  end

  def find_by_id_helper(id, find_class, table_name)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    find_class.new(data_array[0])

  end

end

module DbSave

  def save
    if id
      update
    else
      insert
    end
  end

  def inserter(table_name)
    columns = instance_variables[1..-1].map{|column| column[1..-1]}.join(', ')
    values = instance_variables[1..-1].map{ |var| instance_variable_get(var)}
    values_call = Array.new(values.size) { "?"}
    values_call = values_call.join(",")
    QuestionsDatabase.instance.execute(<<-SQL, *values)
      INSERT INTO
        #{table_name} (#{columns})
      VALUES
        (#{values_call})
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end


  def updater(table_name)
    columns = instance_variables.map{|column| column[1..-1]}.rotate
    values = instance_variables.map{ |var| instance_variable_get(var)}.rotate
    values.map! do |value|
      if value.is_a?(String)
        "'#{value}'"
      else
        value
      end
    end
    nested = columns.each_with_index.map{|column, i| [column, values[i]] if values[i]}.compact
    id_pair = nested.pop.join(" = ")
    nested.map! do |col|
      col.join(" = ")
    end
    nested = nested.join(", ")

    p table_name
    p nested
    p id_pair

    QuestionsDatabase.instance.execute(<<-SQL)
      UPDATE
        #{table_name}
      SET
        #{nested}
      WHERE
        #{id_pair}
    SQL
  end

end


#
# def update
#   QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id, id)
#     UPDATE
#       questions SET title = ?, body = ?, user_id = ?
#     WHERE
#       id = ?
#   SQL
# end
