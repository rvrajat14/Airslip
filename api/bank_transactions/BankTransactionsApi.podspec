Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = 'BankTransactionsApi'
    s.authors = 'Graham Whitehouse'
    s.summary = 'Includes all API endpoints to connect users to their banks using Yapily.'
    s.version = '1.0.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
    s.osx.deployment_target = '10.12'
    s.source_files = 'Sources/**/*.swift'
    s.dependency 'Alamofire', '~> 5.4.3'
end
