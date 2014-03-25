require 'bundler/setup'
require 'tmpdir'
require 'dotenv'
require 'resque'
require 'rest_client'

Dotenv.load

class PrintChart
  @queue = :print_chart
  $redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

  def self.perform(chart_id, printer=nil)
    job = new(chart_id, printer)
    job.print
  end

  # List of available printers
  #
  def self.printers
    JSON.parse($redis.get('printers'))
  rescue Redis::CannotConnectError, TypeError
    []
  end

  # Update list of available printers on the current system
  #
  def self.update_printers!
    printers = `lpstat -a`.split("\n").map {|printer| printer[/\S*/] }
    $redis.set 'printers', printers.to_json
  end

  def initialize(chart_id, printer=nil)
    @chart_id = chart_id
    @chart    = client["/patients/#{chart_id}/chart.pdf"].get
    @printer  = printer
    @printed  = false

    raise ArgumentError.new("Invalid Printer") unless valid_printer?
  end

  attr_reader :chart, :chart_id, :printer, :printed

  def print
    Dir.mktmpdir do |workdir|
      chart_path = "#{workdir}/chart_#{chart_id}.pdf"
      File.binwrite(chart_path, chart)
      @printed = send_to_printer(chart_path)
    end

    update_patient_record(printed)

    printed
  end

  private

  def valid_printer?
    printer.nil? || PrintChart.printers.include?(printer)
  end

  def printer_option
    return unless printer

    "-P #{printer}"
  end

  def send_to_printer(chart_path)
    `lpr #{printer_option} #{chart_path}`
    $?.success?
  end

  def update_patient_record(printed)
    client["/patients/#{chart_id}"].put(patient: {chart_printed: printed})
  end

  def client
    @client ||= RestClient::Resource.new(
      ENV['MOMMA_API_URL'], ENV['MOMMA_API_USER'], ENV['MOMMA_API_PASSWORD'])
  end
end
