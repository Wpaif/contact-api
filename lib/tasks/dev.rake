namespace :dev do
  desc 'set up development environment '
  task setup: :environment do
    show_spinner('Droping DB...') { `rails db:drop` }
    show_spinner('Creating DB...') { `rails db:create` }
    show_spinner('Migrating DB...') { `rails db:migrate` }
    show_spinner('Pupulacing DB...') do
      populace(num_kinds: 10, num_contacts: 10, num_phones: 30, num_addresses: 40)
    end
  end

  private

  def populace(num_kinds:, num_contacts:, num_phones:, num_addresses:)
    num_kinds.times do
      Kind.create_or_find_by!(
        description: Faker::Types.unique.rb_string
      )
    end

    num_contacts.times do
      Contact.create_or_find_by!(
        name: Faker::Name.name,
        email: Faker::Internet.unique.email,
        birthdate: Faker::Date.birthday(min_age: 18),
        kind_id: Kind.all.sample.id
      )
    end

    num_phones.times do
      Phone.create_or_find_by!(
        number: Faker::PhoneNumber.unique.phone_number,
        contact_id: Contact.all.sample.id
      )
    end

    num_addresses.times do 
      Address.create_or_find_by!(
        street: Faker::Address.street_name,
        city: Faker::Address.city,
        contact_id: Contact.all.sample.id
      )
    end
  end

  def show_spinner(msg_start, msg_end = 'Done!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
