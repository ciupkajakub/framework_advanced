require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'behaves as polymorphic' do
    student = Student.create(first_name: 'Bob', last_name: 'Marley', faculty: 'civil_engineering')
    teacher = Teacher.create(first_name: 'John', last_name: 'Wick', years_of_experience: 10)
    _student_post = student.posts.create(title: 'student title', body: 'body by student')
    _student_post = teacher.posts.create(title: 'teacher title', body: 'body by teacher')

    expect(Post.count).to eq(2)
    expect(Student.first.posts.count).to eq(1)
    expect(Teacher.first.posts.count).to eq(1)
  end
end
