require 'bundler/setup'
require 'capybara'
require 'capybara/dsl'
require 'open-uri'
require 'uri'

include Capybara::DSL

TARGET_HOST = "https://starylev.com.ua"

Capybara.register_driver :remote_chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    desired_capabilities: :chrome,
    url: "http://selenium:4444/wd/hub"
  )
end

Capybara.default_driver = :remote_chrome
Capybara.app_host = TARGET_HOST
Capybara.run_server = false

visit '/bookstore'

open("results.txt", "wb") do |file|
  5.times do |i|
    puts "Current URL: #{current_url}"

    books = all ".vsl-bookstore-item-wrap"

    puts "Books: #{books.count}"

    file.write("Сторінка: #{i + 1}\n")
    file.write("-" * 80)

    books.each do |book|
      author = begin
        book.find(".vsl-book-title span").text
      rescue Capybara::ElementNotFound
        "Невідомий автор"
      end
      name = book.find(".vsl-catalogue-item-name").text
      price = book.find(".vsl-price-button span").text

      image_uri = book.find(".vsl-contain-image img")[:src]
      image_basename = File.basename(URI.parse(image_uri).path)

      open("images/#{image_basename}", 'w') do |image_file|
        image_file << open(image_uri).read
      end

      puts "#{author} – #{name} (#{price})"

      file.write("#{author} – #{name} (#{price})\n")
    end

    puts "-" * 80
    file.write("\n")

    click_on "Наступна"
  end
end
