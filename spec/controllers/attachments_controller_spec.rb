require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @project = create(:project)
    @ticket = create(:ticket, project: @project)
    @comment = create(:comment, ticket_id: @ticket.id, commenter: user)
  end

  describe "index" do
    before(:each) do
      create(:attachment, comment: @comment)
      @params = { project_id: @project.id,
                  ticket_id: @ticket.id, comment_id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns allowed attachments" do
          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(@comment.attachments.count)
        end

        it "fails to bring up attachments if comment ID is not provided" do
          @params[:comment_id] = nil
          expect{ get :index, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

      end
    end
  end

  describe "show" do
    before(:each) do
      @attachment = create(:attachment, comment: @comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                  comment_id: @comment.id, id: @attachment.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 404 when not found" do
          @params[:id] = "invalid"
          get :show, params: @params
          expect(response.status).to eq(404)
        end

        it "can be found by it's id" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the attachment" do
          get :show, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@attachment.to_json))
        end
      end
    end
  end

  describe "create" do
    before(:each) do
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment_id: @comment.id,
                  attachment: attributes_for(:attachment) }
    end

    (Member::ROLES - ["restricted"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          post :create, params: @params
          expect(response.status).to eq(200)
        end

        it "uploads the attached file" do
          post :create, params: @params
          expect(@comment.attachments.count).to eq(1)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          post :create, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

  end

  describe "destroy" do
    before(:each) do
      @attachment = create(:attachment, comment: @comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment_id: @comment.id, id: @attachment.id }
    end

    (Member::ROLES - ["restricted", "regular"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end

        it "removes the attachment from the comment" do
          expect{ delete :destroy, params: @params }.to change(Attachment, :count).by(-1)
        end
      end
    end

    ["regular"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when the user is the commenter" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 302 when not the commenter" do
          @comment.commenter = create(:user)
          @comment.save
          delete :destroy, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          delete :destroy, params: @params
          expect(response.status).to eq(302)
        end
      end
    end
  end

  describe "download" do
    before(:each) do
      @attachment = create(:attachment, comment: @comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                  comment_id: @comment.id, id: @attachment.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :download, params: @params
          expect(response.status).to eq(200)
        end

        # it "downloads file when authorised" do
        #   get :download, params: @params
        #   controller.expect(:send_data).return(:success)
        #   # expect(controller).to receive(:send_data) { controller.render nothing: true }
        # end
      end
    end
  end

end