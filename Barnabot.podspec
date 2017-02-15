Pod::Spec.new do |s|
s.name         = "Barnabot"
s.version      = "1.0.0"
s.summary      = "ESGI project"
s.homepage     = "https://github.com/mb2dev/BarnaBot/tree/master"
s.license      = { :type => "BSD", :file => "LICENSE" }
s.author       = { "ESGI" => "contact@esgi.fr" }
s.source       = { :git => "https://github.com/mb2dev/BarnaBot.git", :tag => "v#{s.version}" }
s.source_files = 'Barnabot/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.requires_arc = true
end
