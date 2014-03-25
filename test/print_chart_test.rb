require_relative './test_helper'

describe 'PrintChart', :vcr do
  let(:chart_id) { 1 }

  it 'updates the patient record after printing' do
    PrintChart.stub_any_instance(:send_to_printer, true) do
      print_chart = PrintChart.new(chart_id)
      print_chart.print
    end
  end

  it 'raises an exception if the specified printer is unknown' do
    valid_printers = %w[printer_1 printer_2]

    PrintChart.stub(:printers, [valid_printers]) do
      proc { PrintChart.new(chart_id, 'invalid') }.must_raise ArgumentError
    end
  end

  it 'prints to the specified printer' do
    printer = 'printer_1'

    PrintChart.stub(:printers, [printer]) do
      print_chart = PrintChart.new(chart_id, printer)

      print_chart.printer.must_equal printer
    end
  end
end
