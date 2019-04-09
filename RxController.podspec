#
# Be sure to run `pod lib lint RxController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxController'
  s.version          = '0.1'
  s.summary          = 'A short description of RxController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lm2343635/RxController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lm2343635' => 'lm2343635@126.com' }
  s.source           = { :git => 'https://github.com/lm2343635/RxController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.fczm.pe'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxController/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 4.5'
  s.dependency 'RxCocoa', '~> 4.5'
  s.dependency 'RxFlow', '~> 2.1'
end
