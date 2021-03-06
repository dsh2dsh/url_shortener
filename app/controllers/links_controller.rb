require 'securerandom'

# Handles /links URIs and manipulates with Links for shortened URLs.
class LinksController < ApplicationController
  # Sets @uuid with current user ID.
  before_action :set_uuid, except: :redirect_by_slug

  # Sets @link with requested Link.
  before_action :set_link, only: %i[show edit update destroy]

  # GET /links or /links.json
  #
  # Shows list of valid shortened URLs of current user.
  def index
    @links = Link.where(uuid: @uuid)
  end

  # GET /links/1 or /links/1.json
  #
  # Returns page with properties of this Link. Works only for links
  # generated by current user.
  #
  # Empty, because set_uuid and set_link done everything.
  def show; end

  # GET /links/new
  #
  # Returns data for creating a new Link.
  def new
    @link = Link.new(uuid: @uuid)
  end

  # GET /links/1/edit
  #
  # Returns data for changing requested Link. Works only for links
  # generated by current user.
  #
  # Empty, because set_uuid and set_link done everything.
  def edit; end

  # POST /links or /links.json
  #
  # Creates new Link and redirects to the index if successful. If not
  # - shows the same page with current values and error message.
  def create
    Link.expire_links
    @link = Link.new(link_params)
    @link.uuid = @uuid

    respond_to do |format|
      if @link.save
        format.html do
          redirect_to link_url(@link), notice: 'Link was successfully created.'
        end
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  #
  # Changes requested Link. On successful update shows updated
  # properties of the Link or the edit form for any errors. Works only
  # for links generated by current user.
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html do
          redirect_to link_url(@link), notice: 'Link was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  #
  # Deletes required link and shows list of links. Works only for
  # links generated by current user.
  def destroy
    @link.destroy

    respond_to do |format|
      format.html do
        redirect_to links_url, notice: 'Link was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  # GET /s/1
  #
  # Redirects to :url using :slug as a key. Checks that this link is
  # not expired.
  def redirect_by_slug
    link =
      Link.where(
        'slug = ? AND (expire_at IS NULL OR expire_at >= ?)',
        params[:slug],
        Time.now
      ).take!
    redirect_to link.url, allow_other_host: true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.where(uuid: @uuid, id: params[:id]).take!
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:url, :slug, :expire_at)
  end

  # Extract uuid cookie into @uuid or generate new one.
  def set_uuid
    @uuid = cookies[:uuid] || SecureRandom.uuid
    cookies[:uuid] = { value: @uuid, expires: 1.year }
  end
end
