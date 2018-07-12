class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all.page(params[:page] || 1).order(updated_at: :desc)

    if params[:barcode].present?
      @ticket = Ticket.find_by(params.permit(:barcode))

      if @ticket && !@ticket.passed && @ticket.update(passed: true)
        flash.now[:notice] = 'Ticket passed'
      else
        flash.now[:error] = 'Ticket rejected'
      end
    end
  end

  def pass
    @ticket = Ticket.find_by(params.permit(:barcode))

    if @ticket && !@ticket.passed && @ticket.update(passed: true)
      render :pass
    else
      render :reject
    end
  end

  def import
    Import::Tickets.new(params[:file].tempfile).run!

    redirect_back(fallback_location: tickets_path, notice: 'Tickets successfully imported')
  end
end
