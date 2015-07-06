class CommentObserver < ActiveRecord::Observer
  observe :comment

  cattr_accessor :disable_notifications # use this when doing migrations

  def after_create(record)
    return if CommentObserver.disable_notifications

    #send an email to ticket
    if (record.ticket.assignees.size > 0)
     participants = [record.ticket.assignees, record.user].flatten.compact.uniq

     #dont sent emails to people who have left the project!
Rails.logger.info "participants: #{participants}"
     recipients = participants.select{|r| r.memberships.to_project(record.project.id).any?}.collect(&:email)

     TicketMailer.status_notification(recipients, record).deliver if recipients.any?
    end
  end
end



