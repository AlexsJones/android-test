module PageObjectModel
  class EndOfSampleBookPage < PageObjectModel::Page
    trait "* id:'content' TextView text:'That's the end of this sample! Want to know what happens next? Read on!'"
    element :buy_button, "* id:'button_buy_the_book_now'"
    element :shop_for_more_books, "* id:'button_shop_more_books'"
    element :book_cover, "* id:'bookcover'"
    element :book_title, "* id:'textview_book_title'"
    element :book_author, "* id:'textview_book_author'"
    element :book_publisher, "* id:'textview_book_published'"
    element :book_price, "* id:'textview_price_discounted'"

    def click_on_buy_button
      buy_button.touch
    end

    def click_on_shop_for_more_books_button
      shop_for_more_books.touch
    end
  end
end

module PageObjectModel
  def end_of_sample_book_page
    @_end_of_sample_book_page ||= page(EndOfSampleBookPage)
  end
end
