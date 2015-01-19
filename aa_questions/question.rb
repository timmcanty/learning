
class Question
  extend DatabaseCommands

  def self.find_by_id(id)
    find_by_id_helper(id, self, 'questions')
  end

  def self.find_by_author_id(user_id)
    data_array = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    build_response(Question,data_array)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(data_hash)

    @id = data_hash['id']
    @title = data_hash['title']
    @body = data_hash['body']
    @user_id = data_hash['user_id']
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollower.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
  #
  # def save
  #   if id
  #     update
  #   else
  #     insert
  #   end
  # end

  # def insert
  #   QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id)
  #     INSERT INTO
  #       questions (title, body, user_id)
  #     VALUES
  #       (?, ?, ?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end
  #
  # def update
  #   QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id, id)
  #     UPDATE
  #       questions
  #     SET
  #       title = ?, body = ?, user_id = ?
  #     WHERE
  #       id = ?
  #   SQL
  # end

  def insert
    inserter('questions')
  end

  def update
    updater('questions')
  end


  attr_accessor :title, :body, :id, :user_id

end
