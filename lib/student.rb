require 'pry'
class Student

	attr_accessor :name, :grade
	attr_reader :id

	def initialize(name, grade)
		@name = name
		@grade = grade
	end

	def self.db
		DB[:conn]
	end

	def self.create_table
	    sql =  <<-SQL
	        CREATE TABLE IF NOT EXISTS students (
	        id INTEGER PRIMARY KEY,
	        name TEXT,
	        grade INTEGER
	        )
	        SQL
    	self.db.execute(sql)
    end

    def self.drop_table
    	sql =  <<-SQL
	        DROP TABLE students
	        SQL
    	self.db.execute(sql)
    end

    def save
	    sql = <<-SQL
	      INSERT INTO students (name, grade)
	      VALUES (?, ?)
	    SQL
	    result = self.class.db.execute(sql, self.name, self.grade)
	    # binding.pry
	    sql = <<-SQL
	      SELECT id FROM students
	      WHERE name = ? and grade = ?
	    SQL
	    id = self.class.db.execute(sql, self.name, self.grade).flatten.first
	    @id = id
	    # binding.pry
	    return self
	end

	def self.create(name:, grade:)
		student = Student.new(name, grade)
		student.save
	end

end