class Model
  attr_reader :id

  def self.find(id)
    response = DB.execute(<<-SQL, id)
      SELECT *
      FROM #{table_name}
      WHERE #{table_name}.id = ?
    SQL

    new(response.first)
  end

  def self.all
    response = DB.execute(<<-SQL)
      SELECT *
      FROM #{table_name}
    SQL

    response.map { |data| new(data) }
  end

  def self.single_query(cls, query, *args)
    response = DB.execute(query, *args)[0]
    cls.new(response)
  end

  def self.multi_query(cls, query, *args)
    response = DB.execute(query, *args)
    puts response
    response.map { |data| cls.new(data) }
  end

  def initialize(options = {})
		options = options.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
    @id = options['id']
    column_names.each do |column_name|
      self.send("#{column_name}=", options[column_name.to_s])
    end
  end

  ##fun to build (only got to delete one reviews method, but maybe)
  def self.has_many(others)
    get_many = Proc.new do
      query = <<-SQL
          SELECT #{others}.*
            FROM #{table_name}
            JOIN #{others}
              ON id = #{table_name[0..-2]}_id
           WHERE id = :id
        SQL
      self.class.multi_query(Kernel.const_get(others.to_s[0..-2].capitalize), query, self.id)
    end

    self.send(:define_method, others, &get_many)
  end

  def create
    column_names_s = column_names.join(", ")
    questions_marks_s = Array.new(column_names.count, "?").join(", ")
    query = <<-SQL
      INSERT INTO #{table_name} (#{column_names_s})
      VALUES (#{questions_marks_s})
    SQL

    DB.execute(query, column_values)
    @id = DB.last_insert_row_id
  end

  def update
    sets = column_names.map do |column_name|
      "#{column_name} = ?"
    end.join", "

    query = <<-SQL
      UPDATE #{table_name}
         SET #{sets}
       WHERE id = ?
    SQL

    DB.execute(query, *column_values, id)
  end

  def save
    if @id
      update
    else
      create
    end
  end

  def column_values
    column_names.map { |column_name| self.send(column_name) }
  end

  private
    def self.attr_accessible(*column_names)
      @column_names = column_names.map { |column_name| column_name }
      ##get these column_names and set setters and getters for each
      @column_names.each do |column_name|
        attr_accessor column_name
      end
    end

    def self.column_names
      @column_names
    end

    def column_names
      self.class.column_names
    end

    def table_name
      self.class.table_name
    end
end