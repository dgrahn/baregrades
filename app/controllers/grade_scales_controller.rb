class GradeScalesController < ApplicationController
  # GET /grade_scales
  # GET /grade_scales.json
  def index
    @grade_scales = GradeScale.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grade_scales }
    end
  end

  # GET /grade_scales/1
  # GET /grade_scales/1.json
  def show
    @grade_scale = GradeScale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grade_scale }
    end
  end

  # GET /grade_scales/new
  # GET /grade_scales/new.json
  def new
	@course 		= Course.find(params[:id])
    @grade_scale 	= GradeScale.new
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grade_scale }
    end
  end

  # GET /grade_scales/1/edit
  def edit
	@course 		= Course.find(params[:id])
    @grade_scale 	= @course.grade_scale
  end

  # POST /grade_scales
  # POST /grade_scales.json
  def create
	@course 		= Course.find(params[:course_id])
    @grade_scale 	= GradeScale.new(params[:grade_scale])
	@grade_scale.course_id = params[:course_id]
	
    respond_to do |format|
      if @grade_scale.save
		# Add log
		log = Log.new
		log.course = @course
		log.comments = "#{@current_user.name} added grade scale to course '#{@course.name}'"
		log.save

        format.html { redirect_to @course, notice: 'Grade scale was successfully created.' }
        format.json { render json: @grade_scale, status: :created, location: @grade_scale }
      else
        format.html { render action: "new" }
        format.json { render json: @grade_scale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grade_scales/1
  # PUT /grade_scales/1.json
  def update
	@course 		= Course.find(params[:course_id])
	@grade_scale 	= GradeScale.find(params[:id])

    respond_to do |format|
      if @grade_scale.update_attributes(params[:grade_scale])
        format.html { redirect_to @course, notice: 'Grade scale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @grade_scale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grade_scales/1
  # DELETE /grade_scales/1.json
  def destroy
    @grade_scale = GradeScale.find(params[:id])
    @grade_scale.destroy
	
	# Add log
	log = Log.new
	log.course = @course
	log.comments = "#{@current_user.name} deleted grade scale to course '#{@course.name}'"
	log.save

    respond_to do |format|
      format.html { redirect_to grade_scales_url }
      format.json { head :no_content }
    end
  end
end
