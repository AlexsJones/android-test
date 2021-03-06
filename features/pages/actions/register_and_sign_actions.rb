module PageModels
  module RegisterAndSigninActions
    def enter_app_as_anonymous_user
      welcome_page.try_it_out if welcome_page.displayed?
      dismiss_info_panel
    end

    def enter_app_as_existing_user
      enter_app_as(test_data['users']['existing']['emailaddress'], test_data['users']['existing']['password'])
    end

    def enter_app_as_existing_user_with_a_card
      enter_app_as(test_data['users']['withcard']['emailaddress'], test_data['users']['withcard']['password'])
    end

    def enter_app_as_newly_registered_user
      register_via_welcome_screen
      register_as_new_user
      dismiss_info_panel
    end

    def enter_app_as(username, password)
      if welcome_page.displayed?
        welcome_page.sign_up
      elsif my_library_page.displayed?
        my_library_page.open_menu_and_signin
      end
      sign_in_page.await
      sign_in_page.submit_sign_in_details(username, password)
      dismiss_info_panel
    end

    def dismiss_info_panel
      expect_page(my_library_page)
      my_library_page.dismiss_info_panel
    end

    def register_via_welcome_screen
      welcome_page.sign_up
      click_register_button
    end

    def click_register_button
      sign_in_page.await
      sign_in_page.register
    end

    def submit_sign_in_details(email_address, password)
      sign_in_page.submit_sign_in_details(email_address, password)
    end

    def enter_personal_details(email_address = @email_address)
      expect_page(register_page)
      email_address ||= generate_random_email_address
      first_name = generate_random_first_name
      last_name = generate_random_last_name
      register_page.fill_in_personal_details(first_name, last_name, email_address)
      return email_address, first_name, last_name
    end

    def enter_password(value)
      register_page.fill_in_password(value)
    end

    def set_terms_and_conditions(accept_terms)
      register_page.set_terms_and_conditions(accept_terms)
    end

    def submit_registration_details
      register_page.register_button.scroll_to
      register_page.register_button.touch
      puts "Details used for user registration: #{@email_address}, #{@first_name} #{@last_name}"
    end

    def signin_with_type_of_account(account_type)
      my_library_page.open_menu_and_signin
      sign_in_page.await
      submit_sign_in_details(test_data['users']["#{account_type}"]['emailaddress'], test_data['users']["#{account_type}"]['password'])
    end

    def register_as_new_user
      @email_address, @first_name, @last_name = enter_personal_details
      enter_password(test_data['passwords']['valid_password'])
      set_terms_and_conditions(true)
      submit_registration_details
    end

    def create_new_user
      @first_name, @email_address, @password = api_helper.create_new_user!
      puts "Details used for user creation via api: #{@first_name}, #{@email_address}, #{@password}"
    end

    def create_new_user_with_credit_card
      create_new_user
      @name_on_card = api_helper.add_credit_card
    end

    def sign_in_new_user_with_credit_card
      create_new_user_with_credit_card
      enter_app_as(@email_address, @password)
    end

    def register_via_create_bbb_account_pop_up
      expect(sign_in_page).to have_register_and_signin_pop_up
      sign_in_page.create_my_account.touch
      register_as_new_user
    end

    def sign_in_via_create_bbb_account_pop_up
      expect(shop_page).to have_register_and_signin_pop_up
      sign_in_page.submit_sign_in_details(@email_address, @password)
      #puts @email_address, @password
    end

    def sign_in_with_existing_user_with_saved_card
      enter_app_as(@email_address, @password)
    end
  end
end

World(PageModels::RegisterAndSigninActions)
