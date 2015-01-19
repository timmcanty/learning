require 'singleton'
require 'sqlite3'
require_relative 'database_commands.rb'
require_relative 'reply.rb'
require_relative 'question.rb'
require_relative 'user.rb'

class QuestionsDatabase < SQLite3::Database
  # Ruby provides a `Singleton` module that will only let one
  # `SchoolDatabase` object get instantiated. This is useful, because
  # there should only be a single connection to the database; there
  # shouldn't be multiple simultaneous connections. A call to
  # `SchoolDatabase::new` will result in an error. To get access to the
  # *single* SchoolDatabase instance, we call `#instance`.
  #
  # Don't worry too much about `Singleton`; it has nothing
  # intrinsically to do with SQL.
  include Singleton

  def initialize
    # Tell the SQLite3::Database the db file to read/write.
    super('questions.db')

    # Typically each row is returned as an array of values; it's more
    # convenient for us if we receive hashes indexed by column name.
    self.results_as_hash = true

    # Typically all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end
end

class QuestionFollower
  extend DatabaseCommands
  def self.followers_for_question_id(question_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_followers
      JOIN
        users ON users.id = question_followers.user_id
      WHERE
        question_followers.question_id = ?
    SQL

    build_response(User, data_array)
  end

  def self.followed_questions_for_user_id(user_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_followers
      JOIN
        questions ON questions.id = question_followers.question_id
      WHERE
        question_followers.user_id = ?
    SQL

    build_response(Question, data_array)
  end

  def self.most_followed_questions(n)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_followers
      JOIN
        questions ON questions.id = question_followers.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    build_response(Question, data_array)

  end
end

class QuestionLike
  extend DatabaseCommands
  def self.likers_for_question_id(question_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    build_response(User, data_array)
  end

  def self.num_likes_for_question_id(question_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS count
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL

    return 0 if data_array[0].nil?

    data_array[0]['count']
  end

  def self.liked_questions_for_user_id(user_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    build_response(Question, data_array)
  end

  def self.most_liked_questions(n)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    build_response(Question, data_array)
  end

end
