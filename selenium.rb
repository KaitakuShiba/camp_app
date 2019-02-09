# API
# https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings

require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options

# mail_adress = ENV['MYJOBCAN_MAIL_ADDRESS']
# login_password = ENV['MYJOBCAN_PASSWORD']

driver.navigate.to "https://id.jobcan.jp/users/sign_in"

p "resized"
driver.manage.window.resize_to(800, 800)
p "take screenshot"
driver.save_screenshot "intoli-screenshot.png"

driver.quit
