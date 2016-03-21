class ProjectsController < ApplicationController

  def show
    authorize @project
    params[:tab] = "settings" if @project.created_at == @project.updated_at
  end

  def create
    authorize @project

    #also create an owner membership
    @project.memberships.owner.build(user: current_user)

    # @project.save
    # respond_with(@project)

    respond_to do |format|
      if @project.save
        binding.pry
        format.html { redirect_to project_path(@project, params: {tab: 'settings'}), success: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project}
      else
        format.html { render nil, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @project

    # @project.update(project_params)
    # respond_with(@project)

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_path(@project, params: {tab: "settings"}), success: 'Project was successfully updated.'}
        format.json { render :show, status: :updated, location: @project}
      else
        format.html {
          params[:tab] = "settings"
          render :show, status: :unprocessable_entity
        }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def project_params
    case action_name
    when "create"
      params[:project] ||= {title: "Untitled"}
    end

    params.require(:project).permit(:id, :_destroy, :title)
  end
end
