require 'test_helper'

class Admin::BooksControllerTest < ActionController::TestCase
  setup do
    @admin_book = admin_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_book" do
    assert_difference('Admin::Book.count') do
      post :create, admin_book: { author: @admin_book.author, title: @admin_book.title }
    end

    assert_redirected_to admin_book_path(assigns(:admin_book))
  end

  test "should show admin_book" do
    get :show, id: @admin_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_book
    assert_response :success
  end

  test "should update admin_book" do
    patch :update, id: @admin_book, admin_book: { author: @admin_book.author, title: @admin_book.title }
    assert_redirected_to admin_book_path(assigns(:admin_book))
  end

  test "should destroy admin_book" do
    assert_difference('Admin::Book.count', -1) do
      delete :destroy, id: @admin_book
    end

    assert_redirected_to admin_books_path
  end
end
