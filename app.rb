require "sinatra"
require "sinatra/reloader" if development?
require "pg"
require "active_record"

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "tiy-database"
)

class Employee < ActiveRecord::Base
  has_many :courses

  self.primary_key = :id

  def monthly_salary
    salary / 12.0
  end
end

class Course < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :employee
end

# Sinatra code starts here

# This magic tells Sinatra to close the database connection
# after each request
after do
  ActiveRecord::Base.connection.close
end

get "/" do
  erb :home
end

get "/employees" do
  @employees = Employee.all

  erb :employees
end

get "/new_employee" do
  erb :new_employee
end

post "/create_employee" do
  Employee.create(params)

  redirect to("/employees")
end

get '/show_employee' do
  @employee = Employee.find(params["id"])

  erb :employee
end

get '/edit_employee' do
  @employee = Employee.find(params["id"])

  erb :edit_employee
end

post '/update_employee' do
  employee = Employee.find(params["id"])

  employee.update_attributes(params)

  redirect to("/employees")
end

get '/search_employee' do
  @employees = Employee.where(name: params["search"])

  erb :employees
end

get '/delete_employee' do
  employee = Employee.find(params["id"])
  employee.delete

  redirect to('/employees')
end

get '/courses' do
  @courses = Course.all

  erb :courses
end

get "/new_course" do
  @employees = Employee.all

  erb :new_course
end

get '/search_course' do
  @courses = Course.where(name: params["search"])

  erb :courses
end

get '/show_course' do
  @course = Course.find(params["id"])

  erb :course
end

get '/edit_course' do
  @employees = Employee.all
  @course = Course.find(params["id"])

  erb :edit_course
end

get '/delete_course' do
  course = Course.find(params["id"])
  course.delete

  redirect to('/courses')
end

post "/create_course" do
  Course.create(params)

  redirect to("/courses")
end

post '/update_course' do
  course = Course.find(params["id"])

  course.update_attributes(params)

  redirect to("/courses")
end
