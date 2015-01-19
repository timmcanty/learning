
class User
  extend DatabaseCommands

  def self.find_by_id(id)
    find_by_id_helper(id, self, 'users')
  end

  def self.find_by_name(fname, lname)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    build_response(User , data_array)
  end

  def initialize(data_hash)
    @id = data_hash['id']
    @fname = data_hash['fname']
    @lname = data_hash['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies # should be cleaned up
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    data_array = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        CAST (COUNT(question_likes.id) / COUNT(DISTINCT(questions.id)) AS FLOAT) AS karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.user_id = ?
    SQL

    data_array[0]['karma']
  end

  def insert
    inserter('users')
  end

  def update
    updater('users')
  end

  # def insert
  #   QuestionsDatabase.instance.execute(<<-SQL, fname,lname)
  #     INSERT INTO
  #       users (fname, lname)
  #     VALUES
  #       (?, ?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end
  #
  # def update
  #   QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
  #     UPDATE
  #       users
  #     SET
  #       fname = ?, lname = ?
  #     WHERE
  #       id = ?
  #   SQL
  # end

  attr_accessor :fname, :lname, :id

end
