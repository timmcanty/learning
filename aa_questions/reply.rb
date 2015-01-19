class Reply
  extend DatabaseCommands

  def self.find_by_question_id(question_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL

    build_response(Reply, data_array)
  end

  def self.find_by_user_id(user_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL

    build_response(Reply, data_array)
  end

  def self.find_by_id(id)
    find_by_id_helper(id, self, 'replies')
  end

  def initialize(data_hash)
    @id = data_hash['id']
    @parent_id = data_hash['parent_id']
    @user_id = data_hash['user_id']
    @question_id = data_hash['question_id']
    @body = data_hash['body']
  end

  attr_accessor :body, :id, :parent_id, :user_id, :question_id

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    return nil if parent_id.nil?

    Reply.find_by_id(parent_id)
  end

  def child_replies
    data_array = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    build_response(Reply, data_array)
  end

  # def save
  #   if id
  #     update
  #   else
  #     insert
  #   end
  # end
  #
  # def insert
  #   QuestionsDatabase.instance.execute(<<-SQL, parent_id, user_id, question_id, body)
  #     INSERT INTO
  #       replies (parent_id, user_id, question_id, body)
  #     VALUES
  #       (?, ?, ?, ?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end
  #
  # def update
  #   QuestionsDatabase.instance.execute(<<-SQL, parent_id, user_id, question_id, body, id)
  #     UPDATE
  #       replies
  #     SET
  #       parent_id = ? ,user_id = ?, question_id = ?, body = ?
  #     WHERE
  #       id = ?
  #   SQL
  # end

  def insert
    inserter('replies')
  end

  def update
    updater('replies')
  end


end
