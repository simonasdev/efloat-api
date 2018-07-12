module Import
  class Tickets
    attr_reader :data

    ATTRIBUTE_MAP = {
      ticketID: :identifier,
      barcode: :barcode,
      Passed: :passed,
      CanEnter: :can_enter,
    }.with_indifferent_access

    def initialize file
      @data = Nokogiri::XML(file.read)
    end

    def run!
      tickets = data.root.search('Tickets').flat_map do |node|
        nodes = node.children.select(&:present?)

        ATTRIBUTE_MAP.values_at(*nodes.map(&:name)).zip(nodes.map(&:text)).to_h
      end

      Ticket.transaction do
        tickets.each do |ticket|
          Ticket.find_or_create_by!(ticket)
        end
      end
    end

  end
end
