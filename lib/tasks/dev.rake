namespace :dev do

  DEFAULT_PASSWORD = 123_456
  DEFAULT_FILES_PATH = File.join(Rails.root, "lib", "tmp")

  desc "Set up the development environment"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Deleting BD...") { `rails db:drop` }
      show_spinner("Creating BD...")   { `rails db:create` }
      show_spinner("Migrating BD...")  { `rails db:migrate` }
      show_spinner("Registering the default administrator...") { `rails dev:add_default_admin` }
      show_spinner("Registering extra administrators...") { `rails dev:add_extras_admins` }
      show_spinner("Registering a default user...") { `rails dev:add_default_user` }
      show_spinner("Registering default subjects...") { `rails dev:add_subjects` }
      show_spinner("Registering questions and answers...") { `rails dev:add_answers_and_questions` }
    else
      puts "You have to be in a development environment to run these tasks."
    end
  end

  desc "Add the default administrator"
  task add_default_admin: :environment do
    Admin.create!(
      email: "admin@mail.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add extra administrators"
  task add_extras_admins: :environment do
    10.times do |_i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Add the default user"
  task add_default_user: :environment do
    User.create!(
      email: "user@mail.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adds default subjects"
  task add_subjects: :environment do
    file_name = "subjects.txt"
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, "r").each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Add questions and answers"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |_i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end

  desc "Reset subjects counter"
  task reset_subject_counter: :environment do
    show_spinner("Reset subjects counter...") do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  private

    def create_question_params(subject = Subject.all.sample)
      {
        question: {
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject,
          answers_attributes: []
        }
      }
    end

    def create_answer_params(correct = false)
      { description: Faker::Lorem.sentence, correct: correct }
    end

    def add_answers(answers_array = [])
      rand(2..5).times do |_i|
        answers_array.push(
          create_answer_params
        )
      end
    end

    def elect_true_answer(answers_array = [])
      selected_index = rand(answers_array.size)
      answers_array[selected_index] = create_answer_params(true)
    end

    def show_spinner(msg_start, msg_end = "Successfully concluded!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")
    end
end
