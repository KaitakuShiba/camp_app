require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options

# sec
# wait = Selenium::WebDriver::Wait.new(timeout: 10)
# # wait.until {}

# inputで数を受けられるようにしたい。決まった数を解釈して一気に入力したい

driver.navigate.to "https://id.jobcan.jp/users/sign_in"

mail_adress = ENV['MYJOBCAN_MAIL_ADDRESS']
login_password = ENV['MYJOBCAN_PASSWORD']
driver.find_element(:id, "user_email").send_keys(mail_adress)
driver.find_element(:id, "user_password").send_keys(login_password)
driver.find_element(:xpath, "//*[@id='new_user']/input[3]").click

p "login successfully"

driver.manage.window.resize_to(800, 800)

p "resized"
driver.save_screenshot "sample.png"
p "take screenshot"

driver.quit
