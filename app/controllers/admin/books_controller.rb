class Admin::BooksController < ApplicationController
  before_action :set_admin_book, only: [:show, :edit, :update, :destroy]

  # GET /admin/books
  # GET /admin/books.json
  def index
    @admin_books = Admin::Book.all
  end

  # GET /admin/books/1
  # GET /admin/books/1.json
  def show
  end

  # GET /admin/books/new
  def new
    @admin_book = Admin::Book.new
  end

  # GET /admin/books/1/edit
  def edit
  end

  # POST /admin/books
  # POST /admin/books.json
  def create
    @admin_book = Admin::Book.new(admin_book_params)

    respond_to do |format|
      if @admin_book.save
        format.html { redirect_to @admin_book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @admin_book }
      else
        format.html { render :new }
        format.json { render json: @admin_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/books/1
  # PATCH/PUT /admin/books/1.json
  def update
    respond_to do |format|
      if @admin_book.update(admin_book_params)
        format.html { redirect_to @admin_book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_book }
      else
        format.html { render :edit }
        format.json { render json: @admin_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/books/1
  # DELETE /admin/books/1.json
  def destroy
    @admin_book.destroy
    respond_to do |format|
      format.html { redirect_to admin_books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_book
      @admin_book = Admin::Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_book_params
      params.require(:admin_book).permit(:title, :author)
    end
end
