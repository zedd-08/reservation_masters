class ReceiptGeneratorService
  HELVETICA_FONT_PATH = "app/assets/stylesheets/Helvetica.ttf"
  HELVETICA_BOLD_FONT_PATH = "app/assets/stylesheets/Helvetica-Bold.ttf"
  LOGO_IMG_PATH = "app/assets/images/logo.png"

  def initialize
    @pdf = Prawn::Document.new
    @document_width = @pdf.bounds.width # width fo the document
    @pdf.font_families.update(
      "helvetica" => {
        normal: HELVETICA_FONT_PATH, # Path to the normal (regular) font style
        bold: HELVETICA_BOLD_FONT_PATH, # Path to the bold font style (if applicable)
      },
    )
  end

  def header
    header_column_widths = [@document_width * 2 / 3, @document_width * 1 / 3]
    header_title_data = [["Receipt for your stay at #{@stay.name}", "R##{@reservation.id}"]]
    header_title_options = {
      column_widths: [@document_width * 3 / 4, @document_width * 1 / 4],
      row_colors: ["EDEFF5"],
      cell_style: {
        border_width: 0,
        padding: [10, 5, 10, 10],
        size: 20,
        font: "helvetica",
        font_style: :bold,
      },
    }

    header_logo_data = [[{ image: LOGO_IMG_PATH, position: :left, scale: 0.25, colspan: 6 }]]
    header_logo_options = {
      column_widths: header_column_widths,
      row_colors: ["EDEFF5"],
      cell_style: {
        border_width: 2,
        padding: [5, 5],
        borders: [:bottom],
        border_color: "c9ced5",
      },
    }

    @pdf.table(header_logo_data, header_logo_options)
    @pdf.table(header_title_data, header_title_options) do |table|
      table.row(0..-1).column(1).align = :right
      table.row(0..-1).column(1).size = 10
    end
  end

  def mid_section
    mid_section_data = [["Booked for:", @reservation.name, "Booked on:", @reservation.created_at.strftime("%d-%b-%Y")],
                        ["Check-in date:", "Check-out date:", "Staying for", "Total price:"],
                        [@reservation.check_in.strftime("%d %B, %Y"), @reservation.check_in.strftime("%d %B, %Y"), "#{@reservation.num_of_days} " + "day".pluralize(@reservation.num_of_days), ActiveSupport::NumberHelper::number_to_currency(@reservation.total_amount, :unit => "€", :separator => ",", :delimiter => ".")]]

    mid_section_options = {
      width: @document_width,
      row_colors: ["ffffff"],
      cell_style: {
        border_width: 0,
        borders: [:bottom],
        border_color: "c9ced5",
        padding: [10, 15],
      },
    }

    @pdf.table(mid_section_data, mid_section_options) do |table|
      table.row(0).border_width = 0.5
      table.row(1).text_color = "888892"
      table.row(0).padding = [10, 15]
      table.row(2).size = 11
    end
  end

  def details_section
    stay_reserv_data = [["Details about the your stay and reservation", ""],
                        ["Hotel name", @stay.name],
                        ["Address", @stay.address],
                        ["#{@stay.bedrooms} #{"bedroom".pluralize(@stay.bedrooms)}, #{@stay.bathrooms} #{"bathroom".pluralize(@stay.bathrooms)} - Maximum #{@stay.max_persons} #{"person".pluralize(@stay.max_persons)} allowed", "Pets are#{@stay.max_persons? ? "" : " not"} allowed"],
                        ["", ""],
                        ["Guest details", ""],
                        ["Guest name", @reservation.name],
                        ["Guest email", @reservation.email],
                        ["Guest address", @reservation.address],
                        ["Payment Method", @reservation.pay_type]]

    stay_reserv_data_options = {
      width: @document_width,
      row_colors: ["ffffff"],
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: "c9ced5",
      },
    }

    @pdf.text("\n\n")

    @pdf.table(stay_reserv_data, stay_reserv_data_options) do |table|
      # all rows style
      table.row(1..-1).size = 10
      table.row(1..-1).padding = [8, 12]
      # Header rows style
      table.row(0).background_color = "EDEFF5"
      table.row(0).size = 12
      table.row(0).padding = [7, 15]

      table.row(5).background_color = "EDEFF5"
      table.row(5).size = 12
      table.row(5).padding = [7, 15]
      # Divider row
      table.row(4).borders = []
      # Rows with Title: Value
      table.row(1..2).column(0).font_style = :bold
      table.row(6..9).column(0).font_style = :bold
      # Center all value options
      table.row(1..-1).column(1).align = :center
    end
  end

  def generate_pdf(reservation, stay)
    @reservation = reservation
    @stay = stay

    header
    mid_section
    details_section

    @pdf.text(%{\n\nHope you enjoy your stay at #{@stay.name} from #{@reservation.check_in.strftime("%d %B")} to #{@reservation.check_out.strftime("%d %B, %Y")}!\n\n}, { align: :center })
    @pdf.stroke_horizontal_rule
    @pdf.text("\nRM - Reservation Masters", { align: :center })

    @pdf.render
  end
end
