module PageObjectModel
  class UserLibraryPage < PageObjectModel::Page
    trait "BBBTextView marked:'Your library'"
    element :shop_button, "* id:'button_shop'"
    element :book_cover_first, "BookCover index:0"
    element :signout_button, "TextView marked:'Sign out'"
    element :home_button, "* id:'togglebutton_home'"
    element :your_library_label, "BBBTextView marked:'text1' {text ENDSWITH 'library'}"
    element :refresh_button, "* id:'button_sync'"

    def open_first_book
      book_cover_first.touch
    end

    def goto_shop
      shop_button.touch
    end

    def open_menu
      home_button.tap_when_element_exists(timeout: timeout_short)
      your_library_label.wait_for_element_exists(timeout: timeout_short)
    end

    def links_on_drawer_menu(links)
      links.hashes.map { | x |  Element.new("* marked:\'#{x['links']}'").exists?  }
    end

    def signed_in?
      your_library_label.exists?
    end

    def refresh_image
      refresh_button.exists?
    end

    def sign_out
      open_menu
      signout_button.tap_when_element_exists(timeout: timeout_short)
    end
  end
end

module PageObjectModel
  def user_library_page
    @_user_library_page ||= page(UserLibraryPage)
  end
end
